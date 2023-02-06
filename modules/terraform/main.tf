# Get the stage variable from main module (DEV, TEST, PROD)
variable "stage" {
  type = string
}

# Get the defined location from the main module (switzerlandnorth)
variable "location" {
  type = string
}

# Get the replication type for the storage (LRS, ZRS)
variable "replication" {
  type = string
}

# Get a random prefix for the resources.
variable "random" {
  type = string
}


resource "azurerm_resource_group" "rg-terraform" {
   name     = "${upper(var.stage)}-Terraform"
  location = var.location
  tags = {
    Service = "Terraform",
    Stage = "${upper(var.stage)}"
  }
}

resource "azurerm_storage_account" "storage-terraform" {
  name     = "${lower(var.stage)}terraform${lower(var.random)}"
  resource_group_name = azurerm_resource_group.rg-terraform.name
  location = azurerm_resource_group.rg-terraform.location
  account_tier = "Standard"
  account_replication_type = var.replication

  tags = {
    Service = "Storage",
    Stage = "${upper(var.stage)}"
  }
}

resource "azurerm_storage_container" "container-terraform" {
  name                  = "terraform"
  storage_account_name  = azurerm_storage_account.storage-terraform.name
  container_access_type = "private"
}