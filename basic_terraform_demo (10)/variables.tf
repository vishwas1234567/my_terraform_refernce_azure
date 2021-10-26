variable "name" {
  type        = string
  description = "Name of deployment"
}

variable "environment" {
  type        = string
  description = "Name of the environment"
  default     = "dev"
}

variable "location" {
  type        = string
  description = "Location of resource"
  default     = "East US"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Address of the subnet"
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_space" {
  type        = list(string)
  description = "Address of the subnet"
  default     = ["10.0.0.0/24"]
}