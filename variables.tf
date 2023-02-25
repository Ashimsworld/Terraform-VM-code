variable "resource_group_nmame" {
  type = string
  default = "devops-rg"
}

variable "location" {
  type = string
  default = "West Europe"
}

variable "vnet_name" {
  type = string
  default = "devops-vent"
}

variable "vnet_address_space" {
  type = list(string)
  default = ["10.0.0.0/16"]
}

variable "tags" {
  default = {"created_by"= "terraform", "env" = "dev"}
}

variable "subnet_name" {
  default = "devops-vnet-subnet"
}

variable "subnet_address_prefixe" {
  type = list(string)
  default = ["10.0.1.0/24"]
}

variable "vm_name" {
  default = "dev-vm"
}

variable "admin_username" {
  default = "azadmin"
}

variable "admin_password" {
  default = ""
}

variable "network_interface_name" {
  default = "dev-vm-nif"
}

variable "public_ip_sku" {
  default = "Basic"
}