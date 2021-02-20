terraform {
  required_version = ">= 0.13"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~>2.5.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.6.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>0.7.0"
    }
  }
}
