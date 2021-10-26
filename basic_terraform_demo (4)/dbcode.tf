# SQL SERVER
resource "azurerm_sql_server" "sqlserver" {
  name                         = "${var.app_name}"
  resource_group_name          = "${azurerm_resource_group.resource_gp.name}"
  location                     = "${azurerm_resource_group.resource_gp.location}"
  version                      = "12.0"
  administrator_login          = "<server login Credentials>"
  administrator_login_password = "<server login Credentials>"
}

resource "azurerm_sql_virtual_network_rule" "sqlvnetrule" {
  name                = "sql-vnet-rule"
  resource_group_name = "${azurerm_resource_group.resource_gp.name}"
  server_name         = "${azurerm_sql_server.sqlserver.name}"
  subnet_id           = "${azurerm_subnet.dbsub.id}"
}

# DB SUBNET
resource "azurerm_subnet" "dbsub" {
  name                 = "dbsubn"
  resource_group_name  = "${azurerm_resource_group.resource_gp.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  address_prefix       = "10.0.2.0/24"
  service_endpoints    = ["Microsoft.Sql"]
}