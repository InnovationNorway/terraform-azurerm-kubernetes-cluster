#########################
##-- INPUT VARIABLES --##
#########################

variable "name" {
  type        = string
  description = "Name to make the cluster unique. Example, Projectname or business unit."
}

variable "resource_group" {
  type        = string
  description = "The resource group you want to deploy the AKS cluster in."
}

variable "subnet" {
  type = list(object({
    subnet_name         = string
    vnet_name           = string
    resource_group_name = string
  }))
}

variable "kubernetes_version" {
  type        = string
  default     = "unknown"
}

variable "role_based_access_control" {
  type        = bool
  default     = true
}

variable "enable_pod_security_policy" {
  type        = bool
  default     = false
}

variable "enable_azure_policy" {
  type        = bool
  default     = true
}

variable "default_node_pool" {
  type = list(object({
    name                = string
    vm_size             = string
    node_count          = number
    enable_auto_scaling = bool
    min_count           = number
    max_count           = number
    node_taints         = string
  }))
  default = [
    {
      name                = "default"
      vm_size             = "Standard_D2s_v3"
      node_count          = 3
      enable_auto_scaling = false
      min_count           = 1
      max_count           = 3
      node_taints         = false
    }
  ]
}

variable "additional_node_pools" {
  type = list(object({
    name                = string
    vm_size             = string
    node_count          = number
    vnet_subnet_id      = string
    enable_auto_scaling = bool
    min_count           = number
    max_count           = number
    node_labels         = map(string)
    node_taints         = any
    tags                = map(string)
  }))
}

variable "tags" {
  type = map(string)
}

variable "namespace" {
  type = list(string)
}