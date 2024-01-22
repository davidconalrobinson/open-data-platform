terraform {
  # Replace this with your backend
  backend "local" {
    path = "terraform.tfstate"
  }
}
