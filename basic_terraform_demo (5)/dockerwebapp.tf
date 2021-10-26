provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "resource" {
  name     = "appservice_docker"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "svcplan" {
  name                = "example-appserviceplan"
  location            = azurerm_resource_group.resource.location
  resource_group_name = azurerm_resource_group.resource.name
  kind = "Linux"
  reserved = true
  

  sku {
    tier = "Standard"
    size = "S1" #change the Plan Accordingly
  }
}

locals {
 env_variables = {
   DOCKER_REGISTRY_SERVER_URL            = "URL_DOCKER_HUB_REPO"
   DOCKER_REGISTRY_SERVER_USERNAME       = "USERNAME_DOCKER_HUB"
   DOCKER_REGISTRY_SERVER_PASSWORD       = "PASSWORD_DOCKER_HUB"
 }
}

resource "azurerm_app_service" "myapp" {
  name                = "ddockerizedappwebapp"
  location            = azurerm_resource_group.resource.location
  resource_group_name = azurerm_resource_group.resource.name
  app_service_plan_id = azurerm_app_service_plan.svcplan.id
  

  site_config {
    linux_fx_version = "DOCKER|<repo_name>.azurecr.io/nginxreact"
    # registry_source="Docker Hub"

  }
    app_settings = local.env_variables
    
}

output "id" {
  value = azurerm_app_service_plan.svcplan.id
}