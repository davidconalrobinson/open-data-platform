# open-mds

Welcome to **open-mds** - an Open Source Modern Data Stack! I put this repo together as an experiment to test the feasibility of assembling an enterprise-quality MDS from only open source components.

Note that the implementation in this repo is really just a proof of concept - there are many enhancements that I would want to make before using this in production. Still, all the bare bones are here and functioning - so I think with the right improvements this could be carried forward into a production environment.

## Background

### What is a Modern Data Stack (MDS)?

From [this](https://www.thoughtspot.com/data-trends/best-practices/modern-data-stack) article by Thoughtspot:

> A modern data stack is a collection of tools and cloud data technologies used to collect, process, store, and analyze data.

### Why build and open source MDS?

- Cost! Enterprise data warehouses like Snowflake and BigQuery are expensive. By going open source instead we could provide the same functionality at lower cost.
- Separation of data platform development from data product development. With PaaS and SaaS tools it can be challenging or cost prohibitive to spin up many different environments for data plaform and data product development. This often results in data platform engineers (building the platform) sharing the same development environment as data engineers and analysts (building products ON the platform). Conflicts can arise between these two use cases (e.g.: imagine a data platform engineer trying to test changes to an RBAC model in the same environment where users of that RBAC model are actively developing their own products). By switching to an open-source stack, we have much more flexibility to deploy as many data platform instances as necessary and by doing so we can segretate users based on their specific needs.

## Architecture

open-mds is made up of the following open-source components (at some stage I will put together an architecture diagram to illustrate this more clearly).

Ingress components:
- [Ingress-NGINX](https://github.com/kubernetes/ingress-nginx) load balancer for managing ingress to other deployments within the cluster
- [Cert-Manager](https://cert-manager.io/) for managing/issuing certificates

Platform components:
- [Clickhouse](https://clickhouse.com/) - the datawarehouse (storage and compute)
- [Airflow](https://airflow.apache.org/) - workflow management
- [Superset](https://superset.apache.org/) - BI/reporting/dashboard and SQL interface
- [JupyterHub](https://jupyter.org/hub) - data exploration using IPython notebooks

Other platform components I would like to add in future:
- OpenMetaData - data governance
- MLFlow - ML ops

## Getting started

### Pre-requisites

To deploy open-mds you will first need:
- some familiarity with terraform and kubernetes. You don't need to be an expect by any means, but this readme does assume that you have some basic understanding.
- to install terraform, kubectl and helm:
  ```
  brew install terraform
  brew install kubectl
  brew install helm
  ```
- access to a kubernetes cluster with your context configured locally (a local cluster like minikube is fine for getting started)
- a host domain
- three GitHub apps (to be used as OAuth clients for authenticating users accessing Airflow, Superset and Jupyterhub):
    - Follow the instructions [here](https://docs.github.com/en/apps/creating-github-apps/registering-a-github-app/registering-a-github-app) to register three GitHub Apps
    - For each GitHub App you will need to configure as shown below. Make a note of the client ID and client secret for each GitHub App.
      ```
      For deployment on a local cluster:
        Airflow:
            Homepage URL: http://localhost:8000
            Callback URL: http://localhost:8000/oauth-authorized/github
        Superset:
            Homepage URL: http://localhost:8000
            Callback URL: http://localhost:8000/oauth-authorized/github
        JupyterHub:
            Homepage URL: http://localhost:8000
            Callback URL: http://localhost:8000/hub/oauth_callback

      For deployment on a remote cluster (where <namespace> is the namespace on your cluster that you will deploy to, and <host> is your host domain):
        Airflow:
            Homepage URL: https://airflow.<namespace>.<host>
            Callback URL: https://airflow.<namespace>.<host>/oauth-authorized/github
        Superset:
            Homepage URL: https://superset.<namespace>.<host>
            Callback URL: https://superset.<namespace>.<host>/oauth-authorized/github
        JupyterHub:
            Homepage URL: https://jupyterhub.<namespace>.<host>
            Callback URL: https://jupyterhub.<namespace>.<host>/hub/oauth_callback
      ```

### Deploying using terraform

- Create a `vars.tfvars` file in the `terraform/` directory and populate it with the variables required by the `open_mds` terraform module. There is an example file in `terraform/vars.tfvars.example` that you can use as a template. Refer to `terraform/open_mds/variables.tf` for variable descriptions and types. Note that:
    - For deploying to a local kubernetes cluster you can set the `host` to `http://localhost:8000`. Otherwise this should be the `host` where you intend to make your open-mds deployment accessible from outside your cluster (i.e.: `my.domain.com`).
    - open-mds uses GitHub apps as OAuth clients for authorising access. In order to be authorised you will need to add your GitHub username under the `RBAC` map.
    - This implementation uses [letsencrypt](https://letsencrypt.org/) for certificate signing. Letsencrypt has very strict rate limits in production, so for testing/development it is best to set `lets_encrypt_environment` to `staging`.
- Run the following commands to deploy open-mds on your cluster:
  ```
  cd terraform
  terraform init
  terraform apply -var-file=vars.tfvars
  ```
- Verify that all pods are up and running:
  ```
  kubectl get pods -n <platform_namespace specified in vars.tfvars file>
  ```

### Accessing open-mds from a local cluster deployment

- Port forward to one of the following services:
    - Airflow
      ```
      kubectl port-forward svc/airflow-webserver -n <platform_namespace specified in vars.tfvars file> 8000:8080
      ```
    - Superset
      ```
      kubectl port-forward svc/superset -n <platform_namespace specified in vars.tfvars file> 8000:8088
      ```
    - Jupyterhub
      ```
      kubectl port-forward svc/hub -n <platform_namespace specified in vars.tfvars file> 8000:8081
      ```
- Open a browser and go to `http://localhost:8000`. Your browser will probably warn you that the site's certificate cannot be trusted. You can ignore this warning for now because we still have not configured a host and DNS records.
- Click to login using GitHub. You will be prompted to authorise access, and then you will be redirected to the homepage of the service. At this point you should have access and everything should be working as expected.

### Accessing open-mds from a remote cluster deployment

- First register your host domain with your cloud service provider and make sure that it is directing traffic to the external IP address of the ingress-nginx load balancer (you can check this IP address by running `kubectl get services ingress-nginx -n <ingress namespace>`)
- Add the following DNS A records to your host domain:
    - `<ingress namespace>`
    - `airflow.<platform namespace>`
    - `superset.<platform namespace>`
    - `jupyterhub.<platform namespace>`
- Open a browser and go to `https://< airflow | superset | jupyterhub >.<host>`.
- Click to login using GitHub. You will be prompted to authorise access, and then you will be redirected to the homepage of the service. At this point you should have access and everything should be working as expected.

### Deploying a custom configuration

For customising the deployment configuration, you can modify the helm `values.yaml` file for each component in the [charts](charts/) directory. Refer to the links below for documentation on the parameters that can be set:

- ingress-nginx [`values.yaml`](https://github.com/kubernetes/ingress-nginx/blob/release-1.9/charts/ingress-nginx/values.yaml)
- cert-manager [`values.yaml`](https://github.com/cert-manager/cert-manager/blob/v1.13.3/deploy/charts/cert-manager/values.yaml)
- clickhouse [`values.yaml`](https://github.com/bitnami/charts/blob/5687b241a2daa04df4b38f8e4d7dd110c64f5c7c/bitnami/clickhouse/values.yaml)
- airflow [`values.yaml`](https://github.com/apache/airflow/blob/helm-chart/1.11.0/chart/values.yaml)
- superset [`values.yaml`](https://github.com/apache/superset/blob/superset-helm-chart-0.11.2/helm/superset)
- jupyterhub [`values.yaml`](https://github.com/jupyterhub/zero-to-jupyterhub-k8s/blob/3.2.1/jupyterhub/values.yaml)

## RBAC

open-mds has an RBAC model at the platform level with five platform roles. Each of these roles maps to a set of roles from the underlying applications. This RBAC model is somewhat arbitraty - the intention here was to prove that a platform-level RBAC model is feasible to implement. Ultimately we could configure any number of different platform roles and map them to any custom roles as required.

| Platform role | Superset          | Jupyterhub    | Airflow   |
| ------------- |:-----------------:|:-------------:|:---------:|
| Admin         | [admin](https://superset.apache.org/docs/security/#admin)             | [admin](https://jupyterhub.readthedocs.io/en/stable/rbac/roles.html)         | [admin](https://airflow.apache.org/docs/apache-airflow/stable/security/access-control.html#admin)     |
| Engineer      | [alpha](https://superset.apache.org/docs/security/#alpha), [sql_lab](https://superset.apache.org/docs/security/#sql_lab)    | [user](https://jupyterhub.readthedocs.io/en/stable/rbac/scopes.html#default-user-scope-target)          | [op](https://airflow.apache.org/docs/apache-airflow/stable/security/access-control.html#op)        |
| Scientist     | [alpha](https://superset.apache.org/docs/security/#alpha), [sql_lab](https://superset.apache.org/docs/security/#sql_lab)    | [user](https://jupyterhub.readthedocs.io/en/stable/rbac/scopes.html#default-user-scope-target)          | [user](https://airflow.apache.org/docs/apache-airflow/stable/security/access-control.html#user)      |
| Analyst       | [alpha](https://superset.apache.org/docs/security/#alpha), [sql_lab](https://superset.apache.org/docs/security/#sql_lab)    |               | [user](https://airflow.apache.org/docs/apache-airflow/stable/security/access-control.html#user)      |
| Viewer        | [gamma](https://superset.apache.org/docs/security/#gamma)             |               |           |

Currently I have not implemented an RBAC model for data-level access, although this is something I would also like to experiment with.

## Links

Some useful links that were helpful for setting up open-mds

- Setting up kubernetes ingress using ingress-nginx https://github.com/digitalocean/Kubernetes-Starter-Kit-Developers/blob/main/03-setup-ingress-controller/nginx.md
- Deploying helm charts with terraform https://github.com/ryderdamen/digital_ocean_kubernetes_web_server_tls/tree/main
- Workaround for a bug using terraform `helm_release` resource to deploy Airflow helm chart
https://forum.astronomer.io/t/run-airflow-migration-and-wait-for-airflow-migrations/1189/10
- Airflow GitHub OAuth https://airflow.apache.org/docs/apache-airflow/stable/security/webserver.html
- JupyterHub GitHub OAuth https://oauthenticator.readthedocs.io/en/latest/tutorials/provider-specific-setup/providers/github.html#
- Superset GitHub OAuth https://stackoverflow.com/questions/71748176/using-github-oauth-for-superset
