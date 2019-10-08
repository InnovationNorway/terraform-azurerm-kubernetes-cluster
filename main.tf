data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_kubernetes_service_versions" "main" {
  location = local.location
}

data "azuread_service_principal" "main" {
  application_id = var.service_principal.client_id
}

resource "azurerm_kubernetes_cluster" "main" {
  name     = var.name
  location = data.azurerm_resource_group.main.location

  resource_group_name = data.azurerm_resource_group.main.name

  dns_prefix = var.name

  kubernetes_version = var.kubernetes_version

  node_resource_group = var.node_resource_group

  addon_profile {
    kube_dashboard {
      enabled = false
    }
  }

  dynamic "agent_pool_profile" {
    for_each = local.node_pools

    content {
      name                = agent_pool_profile.value.name
      count               = agent_pool_profile.value.count
      vm_size             = agent_pool_profile.value.vm_size
      enable_auto_scaling = length(agent_pool_profile.value.scaling) > 0 ? true : false
      min_count           = agent_pool_profile.value.scaling.min
      max_count           = agent_pool_profile.value.scaling.max
      max_pods            = agent_pool_profile.value.max_pods
      os_type             = "Linux"
      os_disk_size_gb     = agent_pool_profile.value.os_disk_size
      type                = "VirtualMachineScaleSets"
      vnet_subnet_id      = agent_pool_profile.value.subnet_id
      node_taints         = agent_pool_profile.value.node_taints
    }
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    dns_service_ip     = cidrhost(var.network.service_cidr, 10)
    docker_bridge_cidr = var.network.docker_bridge_cidr
    service_cidr       = var.network.service_cidr
    load_balancer_sku  = "standard"
  }

  role_based_access_control {
    enabled = true
  }

  service_principal {
    client_id     = var.service_principal.client_id
    client_secret = var.service_principal.client_secret
  }

  tags = var.tags
}

resource "azurerm_role_assignment" "main" {
  count                = length(var.node_pools[*].subnet_id)
  scope                = var.node_pools[count.index].subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = data.azuread_service_principal.main.object_id
}
