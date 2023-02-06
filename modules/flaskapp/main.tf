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

# Get the defined SKU for the App Service Plan
variable "skuwebapps" {
  type = string
}

# Get the defined OS for the App Service Plan
variable "oswebapps" {
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
  version                = "8.0.21"
  tags = {
    Service = "Database",
    Stage = "${upper(var.stage)}"
  }
}

resource "azurerm_service_plan" "asp-webapps" {
  name                = "asp-${lower(var.stage)}-webapps"
  location            = var.location
  resource_group_name = var.rgwebapps
  os_type             = "${var.oswebapps}"
  sku_name            = "${var.skuwebapps}"
  tags = {
    Service = "WebApps",
    Stage = "${upper(var.stage)}"
  }
}

# Create a Web App in the App Service Plan.
resource "azurerm_linux_web_app" "wa-testapp" {
  name                = "wa-todo-${lower(var.stage)}-${lower(var.random)}"
  resource_group_name = var.rgwebapps
  location            = var.location
  service_plan_id     = azurerm_service_plan.asp-webapps.id
  tags = {
    Service = "WebApps",
    Stage = "${upper(var.stage)}"
  }

  site_config {
    application_stack {
      python_version    = "3.10"
    }
    always_on = false
    app_command_line = "gunicorn --bind=0.0.0.0:8000 --timeout 600 todo:app"
  }
}

#  Deploy code from a public GitHub repo
resource "azurerm_app_service_source_control" "sourcecontrol" {
  app_id             = azurerm_linux_web_app.wa-testapp.id
  repo_url           = "https://github.com/Xenad0/VCID-App"
  branch             = "main"
}