resource "azurerm_resource_group" "resource_gp" {
  name     = "Vishwasdemo"
  location = "eastus"

  tags {
    Owner = "Vishwas NArayan"
  }
}
