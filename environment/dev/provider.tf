provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "cloidilm-prod"

    workspaces {
      name = "cloudilm-networking"
    }
  }
}