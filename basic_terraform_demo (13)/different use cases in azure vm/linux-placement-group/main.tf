terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.70.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.1.0"
    }
  }
  required_version = ">=0.15.0"
}

provider "azurerm" {
  features {}
}

resource "random_string" "random" {
  length  = 12
  upper   = false
  special = false
}

data "azurerm_subscription" "current" {
}

module "subscription" {
  source          = "https://github.com/<projecct-repo>"
  subscription_id = data.azurerm_subscription.current.subscription_id
}

module "naming" {
  source = "https://github.com/<projecct-repo>"
}

module "metadata" {
  source = "https://github.com/<projecct-repo>"

  naming_rules = module.naming.yaml

  market              = "us"
  project             = "https://github.com/<projecct-repo>"
  location            = "eastus2"
  environment         = "sandbox"
  product_name        = random_string.random.result
  business_unit       = "infra"
  product_group       = "contoso"
  subscription_id     = module.subscription.output.subscription_id
  subscription_type   = "dev"
  resource_group_type = "app"
}

module "resource_group" {
  source = "https://github.com/<projecct-repo>"

  location = module.metadata.location
  names    = module.metadata.names
  tags     = module.metadata.tags
}

module "virtual_network" {
  source = "https://github.com/<projecct-repo>"

  naming_rules = module.naming.yaml

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  names               = module.metadata.names
  tags                = module.metadata.tags

  address_space = ["10.1.0.0/22"]

  subnets = {
    "iaas-public" = { cidrs = ["10.1.0.0/24"]
      allow_vnet_inbound  = true
      allow_vnet_outbound = true
    }
    "iaas-private" = { cidrs = ["10.1.1.0/24"]
      allow_vnet_inbound  = true
      allow_vnet_outbound = true
    }
  }
}

resource "azurerm_proximity_placement_group" "primary" {
  name                = "example-placement-group"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  tags                = module.metadata.tags
}

module "linux_virtual_machine" {
  source = "../../"

  # Create two VMs
  count = 2

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  names               = module.metadata.names
  tags                = module.metadata.tags

  # Windows or Linux?
  kernel_type = "linux"

  # Instance Size
  virtual_machine_size = "Standard_D2as_v4"

  # Operating System Image
  source_image_publisher = "Canonical"
  source_image_offer     = "UbuntuServer"
  source_image_sku       = "18.04-LTS"
  source_image_version   = "latest"

  # Virtual Network
  subnet_id = module.virtual_network.subnets["iaas-public"].id

  # Networking
  accelerated_networking    = true
  proximity_placement_group = azurerm_proximity_placement_group.primary.id

}