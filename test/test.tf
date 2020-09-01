##- Terraform configuration & required providers -##
terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = "2.25.0"
  }
}
provider azurerm {
  features {}
}

data "azurerm_virtual_network" "aks" {
  name                = "core-k8s-test-vnet"
  resource_group_name = "core-k8s-test"
}

data "azurerm_subnet" "aks" {
  name                 = "AKS"
  virtual_network_name = data.azurerm_virtual_network.aks.name
  resource_group_name  = "core-k8s-test"
}

module "aks" {
  source = "../terraform-azurerm-kubernetes-cluster"

  name                        = "coretest"
  resource_group              = "core-k8s-test"
  #kubernetes_version         = "1.12.4"
  enable_pod_security_policy  = false

  subnet = [{
    vnet_name           = data.azurerm_virtual_network.aks.name
    subnet_name         = data.azurerm_subnet.aks.name
    resource_group_name = "core-k8s-test"
  }]

  default_node_pool = [{
      name                = "pool01"
      vm_size             = "Standard_D4s_v3"
      node_count          = null
      enable_auto_scaling = true
      min_count           = 1
      max_count           = 3
      node_taints         = ""
    }]

  additional_node_pools = [
    {
      name       = "criticalonly"
      vm_size    = "Standard_D2s_v3"
      node_count = null

      vnet_subnet_id = data.azurerm_subnet.aks.id

      enable_auto_scaling = true
      min_count           = 2
      max_count           = 5

      node_taints = ["CriticalAddonsOnly=true:NoSchedule"]
      node_labels = {}

      tags = {
        source = "terraform"
      }
    }
  ]
  tags = {
  environment="test"
  source="terraform"
  }
}