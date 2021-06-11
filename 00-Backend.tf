terraform {
  backend "azurerm" {
    resource_group_name  = "aznp-tfstate-rg"
    storage_account_name = "aznptf16xec3nz"
    container_name       = "core-tfstate"
    key                  = "tf-aznpmod05.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }

  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}





