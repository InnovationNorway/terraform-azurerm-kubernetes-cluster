# Kubernetes Cluster

Create managed Kubernetes cluster (AKS) in Azure.

## Example Usage

```hcl
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "westeurope"
}

module "service_principal" {
  source = "innovationnorway/service-principal/azuread"
  name   = "example"
}

module "kubernetes_cluster" {
  source = "innovationnorway/kubernetes-cluster/azurerm"

  name = "example-cluster"

  resource_group_name = azurerm_resource_group.example.name

  node_pools = [
    {
      name    = "default"
      vm_size = "Standard_DS2_v2"
      scaling = {
        min = 1
        max = 3
      }
      subnet_id = azurerm_subnet.example.id
    }
  ]

  service_principal = module.service_principal
}
```

## Arguments

| Name | Type | Description |
| --- | --- | --- |
| `name` | `string` | The name of the managed cluster. |
| `resource_group_name` | `string` | The name of an existing resource group. |
| `kubernetes_version` | `string` | The Kubernetes version to use. |
| `node_resource_group` | `string` | The name of the node resource group. |
| `node_pools` | `list` | List of node pools. This should be `node_pools` object. |
| `network` | `object` | A `network` object. |
| `service_principal` | `object` | A `service_principal` object. |
| `tags` | `map` | A mapping of tags to assign to the resources. |

The `node_pools` object accepts the following keys:

| Name | Type | Description |
| --- | --- | --- |
| `name` | `string` | The name of the node pool. |
| `vm_size` | `string` | The size of the VMs in the node pool. |
| `count` | `number` | The number of nodes. |
| `scaling` | `object` | Enables autoscaler. This should be `scaling` object. |
| `subnet_id` | `string` | The ID of the subnet. |

The `scaling` object must have the following keys:

| Name | Type | Description |
| --- | --- | --- |
| `min` | `number` | The minimum number of nodes. |
| `max` | `number` | The maximum number of nodes. |

The `network` object must have the following keys:

| Name | Type | Description |
| --- | --- | --- |
| `service_cidr` | `string` | The range of IP addresses for service VIPs. |

The `service_principal` object must have the following keys:

| Name | Type | Description |
| --- | --- | --- |
| `client_id` | `string` | The client ID for the service principal. |
| `client_secret` | `string` | The client secret for the service principal. |
