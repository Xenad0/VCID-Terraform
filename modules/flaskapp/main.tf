# Get the stage variable from main module (DEV, TEST, PROD)
variable "stage" {
  type = string
}

# Get the defined location from the main module (switzerlandnorth)
variable "location" {
  type = string
}

variable "rgstorage" {
  type = string
}

variable "rgwebapps" {
  type = string
}

# Get a random prefix for the resources.
variable "random" {
  type = string
}

resource "azurerm_mysql_flexible_server" "database" {
  name                   = "${lower(var.stage)}database${lower(var.random)}"
  resource_group_name    = var.rgstorage
  location               = var.location
  administrator_login    = "dbadmin"
  administrator_password = "1$M^E2s!jLgkcn3o2Tyd:A87JAIM"
  backup_retention_days  = 7
  sku_name               = "B_Standard_B1ms"
}