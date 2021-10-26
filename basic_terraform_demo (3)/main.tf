#Resource Group Creation
resource "azurerm_resource_group" "resource_gp" {
  name     = "Vishwas-Terraform-Demo"
  location = "eastus"

  tags {
    Owner = "Vishwas N"
  }
}
