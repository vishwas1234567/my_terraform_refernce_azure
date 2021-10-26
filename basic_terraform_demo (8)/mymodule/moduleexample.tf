resource "azurerm_resource_group" "resource_gp" {
  name     = "demo_modules"
  location = "eastus"

  tags {
    Owner = "Vishwas"
  }
}
