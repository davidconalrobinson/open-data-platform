# Open Data Platform

[![Super-Linter](https://github.com/<OWNER>/<REPOSITORY>/actions/workflows/<WORKFLOW_FILE_NAME>/badge.svg)](https://github.com/marketplace/actions/super-linter)

## Quick start

### Local pre-requisites

### Cloud pre-requisites

### Deploying using terraform

```
cd terraform
terraform init
terraform apply -var-file=vars.tfvars
```

## Deploying a custom configuration

For customising the deployment configuration, you can modify the helm `values.yaml` file for each component in the [charts](charts/) directory. Refer to the links below for documentation on the parameters that can be set:

- airflow [`values.yaml`](https://github.com/apache/airflow/blob/helm-chart/1.11.0/chart/values.yaml)
- cert-manager [`values.yaml`](https://github.com/cert-manager/cert-manager/blob/v1.13.3/deploy/charts/cert-manager/values.yaml)
- clickhouse [`values.yaml`](https://github.com/bitnami/charts/blob/5687b241a2daa04df4b38f8e4d7dd110c64f5c7c/bitnami/clickhouse/values.yaml)
- ingress-nginx [`values.yaml`](https://github.com/kubernetes/ingress-nginx/blob/release-1.9/charts/ingress-nginx/values.yaml)
- jupyterhub [`values.yaml`](https://github.com/jupyterhub/zero-to-jupyterhub-k8s/blob/3.2.1/jupyterhub/values.yaml)
- metabase [`values.yaml`](https://github.com/pmint93/helm-charts/blob/metabase-2.10.4/charts/metabase/values.yaml)

## Architecture

## Some useful links

- Setting up kubernetes ingress using ingress-nginx https://github.com/digitalocean/Kubernetes-Starter-Kit-Developers/blob/main/03-setup-ingress-controller/nginx.md
- Setting out LDAP authentication using openLDAP and Keycloak https://www.talkingquickly.co.uk/installing-openldap-kubernetes-helm
- Using `ldapsearch` https://www.splunk.com/en_us/blog/tips-and-tricks/ldapsearch-is-your-friend.html
- Hosting Metabase web app from domain with sub-path https://github.com/pmint93/helm-charts/issues/94#issuecomment-1879444396
- Deploying helm charts with terraform https://github.com/ryderdamen/digital_ocean_kubernetes_web_server_tls/tree/main
- https://forum.astronomer.io/t/run-airflow-migration-and-wait-for-airflow-migrations/1189/10
- Configuring a GitHub OAuth app for Airflow https://airflow.apache.org/docs/apache-airflow/stable/security/webserver.html
- JupyterHub OAuth https://oauthenticator.readthedocs.io/en/latest/tutorials/provider-specific-setup/providers/github.html#
