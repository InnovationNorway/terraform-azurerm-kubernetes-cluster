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

## Arguments

| Name | Type | Description |
| --- | --- | --- |
| `name` | `string` | The name of the managed cluster. |
| `resource_group` | `string` | The name of an existing resource group. |
| `kubernetes_version` | `string` | The Kubernetes version to use, defaults to latest stable version. |
| `default_node_pool` | `list` | List of configuration options for the default node pool. |
| `subnet` | `list` | List to identify the subnet we want to deploy to. |
| `tags` | `map` | A mapping of tags to assign to the resources. |

`default_node_pool`:

| Name | Type | Description |
| --- | --- | --- |
| `name` | `string` | The name of the node pool. |
| `vm_size` | `string` | The size of the VMs in the node pool. |
| `node_count` | `number` | The number of nodes. |


`subnet`:

| Name | Type | Description |
| --- | --- | --- |
| `subnet_name` | `string` | The name of the subnet. |
| `vnet_name` | `string` | The VNet the subnet is located in. |
| `resource_group_name` | `string` | The resource group the VNet is located in. |
