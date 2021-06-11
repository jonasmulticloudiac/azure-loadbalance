terraform {
  required_version = "= 0.13.6"
  backend "azurerm" {
    resource_group_name  = "aznp-tfstate-rg"
    storage_account_name = "aznptf16xec3nz"
    container_name       = "core-tfstate"
    key                  = "aznp-mod05-terraform.tfstate"
  }
}


# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}




