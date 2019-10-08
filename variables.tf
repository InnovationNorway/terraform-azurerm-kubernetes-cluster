variable "name" {
  type        = string
  description = "The name of the managed cluster."
}

variable "resource_group_name" {
  type        = string
  description = "The name of an existing resource group."
}

variable "location" {
  type        = string
  default     = ""
  description = "The location where the resources should be created."
}

variable "kubernetes_version" {
  type        = string
  default     = null
  description = "The Kubernetes version to use."
}

variable "node_resource_group" {
  type        = string
  default     = null
  description = "The name of the node resource group."
}

variable "node_pools" {
  type        = any
  description = "List of node pools. This should be `node_pools` object."
}

variable "service_principal" {
  type = object({
    client_id     = string
    client_secret = string
  })
  description = "A `service_principal` object."
}

variable "network" {
  type = object({
    docker_bridge_cidr = string
    service_cidr       = string
  })
  default = {
    docker_bridge_cidr = "172.17.0.1/16"
    service_cidr       = "172.19.0.0/16"
  }
  description = "A `network` object."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags to assign to the resources."
}

locals {
  location = coalesce(var.location, data.azurerm_resource_group.main.location)

  node_pools = [
    for p in var.node_pools : merge({
      name    = ""
      count   = null
      vm_size = "Standard_DS2_v2"
      scaling = {
        min = 1
        max = 3
      }
      max_pods     = 30
      os_disk_size = 128
      node_taints  = null
    }, p)
  ]

  supported_versions      = data.azurerm_kubernetes_service_versions.main.versions
  check_supported_version = var.kubernetes_version != null ? local.supported_versions[var.kubernetes_version] : null
}
