# Kubernetes Cluster

Module for creating a managed Kubernetes cluster (AKS). 

## Example of use
```hcl
module "aks" {
  source  = "innovationnorway/kubernetes-cluster/azurerm"

  name_prefix    = "example"
  resource_group = "example-rg"

  default_node_pool = {
      name       = "default"
      vm_size    = "Standard_F2s_v2"
      node_count = 2
    }

  additional_node_pools = [
    {
      name       = "pool2"
      vm_size    = "Standard_F2s_v2"
      node_count = 1
      tags = {
        source = "terraform"
      }
    },
    {
      name       = "pool3"
      vm_size    = "Standard_F2s_v2"
      node_count = 3
      tags = {
        source = "terraform"
      }
    }
  ]
}
##- Terraform configuration & required providers -##
terraform {
  required_version = ">= 0.13"
  required_providers {
    azuread = "0.11.0"
    azurerm = "2.20.0"
  }
}
```