######################
##-- Local Values --##
######################
locals {
  additional_node_pools = flatten([
    for np in var.additional_node_pools : {
      name         = np.name
      vm_size      = np.vm_size
      node_count   = np.node_count
      tags         = np.tags
    }
  ])
}