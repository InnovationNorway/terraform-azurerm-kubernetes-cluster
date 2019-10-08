variable "location" {
  type    = string
  default = "westeurope"
}

resource "random_id" "test" {
  byte_length = 2
}

resource "azurerm_resource_group" "test" {
  name     = format("test-%s", random_id.test.hex)
  location = var.location
}

resource "azurerm_virtual_network" "test" {
  name                = format("test-%s", random_id.test.hex)
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "test" {
  name                 = format("test-%s", random_id.test.hex)
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefix       = cidrsubnet(azurerm_virtual_network.test.address_space[0], 4, 2)
}

module "service_principal" {
  source = "innovationnorway/service-principal/azuread"
  name   = format("test-%s", random_id.test.hex)
}

module "kubernetes_cluster" {
  source = "../"

  name = format("test-%s", random_id.test.hex)

  resource_group_name = azurerm_resource_group.test.name

  node_pools = [
    {
      name    = "default"
      vm_size = "Standard_DS2_v2"
      scaling = {
        min = 1
        max = 3
      }
      subnet_id = azurerm_subnet.test.id
    }
  ]

  service_principal = module.service_principal
}
