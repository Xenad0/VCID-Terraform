# Get the stage variable from main module (DEV, TEST, PROD)
variable "stage" {
  type = string
}

# Get the defined location from the main module (switzerlandnorth)
variable "location" {
  type = string
}

# Create a resourcegroup for all storage services.
resource "azurerm_resource_group" "rg-storage" {
  name     = "${upper(var.stage)}-Storage"
  location = var.location
  tags = {
    Service = "Storage",
    Stage = "${upper(var.stage)}"
  }
}

# Create a resourcegroup for all webapps and functions.
resource "azurerm_resource_group" "rg-webapps" {
  name     = "${upper(var.stage)}-WebApps"
  location = var.location
  tags = {
    Service = "Webapps",
    Stage = "${upper(var.stage)}"
  }
}