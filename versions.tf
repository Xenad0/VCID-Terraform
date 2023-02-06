terraform {
  backend "azurerm" {
    resource_group_name  = "PROD-Terraform"
    storage_account_name = "prodterraform02aaf488"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
  }
  required_providers {
    azurerm = {
      # Module for all Azure resources.
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    # Module for random generation of strings.
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

# Import the Azure Provider in the project.
provider "azurerm" {
  features {}
}