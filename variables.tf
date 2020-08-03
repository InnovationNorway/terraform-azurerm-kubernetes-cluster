#########################
##-- INPUT VARIABLES --##
#########################

variable "name_prefix" {
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
  default     = false
}
variable "enable_pod_security_policy" {
  type        = bool
  default     = true
}
variable "default_node_pool" {
  type        = map
}

variable "additional_node_pools" {
  type = list(object({
    name         = string
    vm_size      = string
    node_count   = number
    tags         = map(string)
  }))
}