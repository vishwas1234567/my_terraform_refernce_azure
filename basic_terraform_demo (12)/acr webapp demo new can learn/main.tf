provider "azurerm" {
  version = "=1.44.0"
}

resource "azurerm_resource_group" "default" {
  name     = "${var.name}-${var.environment}-rg"
  location = "${var.location}"
}
