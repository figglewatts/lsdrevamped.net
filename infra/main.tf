terraform {
  required_version = ">= 0.12"
  backend "s3" {
    skip_requesting_account_id  = true
    skip_credentials_validation = true
    skip_get_ec2_platforms      = true
    skip_metadata_api_check     = true
    endpoint                    = "https://fra1.digitaloceanspaces.com"
    region                      = "eu-west-1" # this isn't used
    key                         = "lsdrevamped.net.tfstate"
  }
}

provider "azurerm" {
  version = "=2.6.0"

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id

  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-lsdr-site"
  location = "UK South"
}
