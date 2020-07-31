##################################
##-- AZURE KUBERNETES SERVICE --##
##################################

##- AKS cluster -##
resource "azurerm_kubernetes_cluster" "cluster" {
  # Set name, location, resource group and dns prefix
  name                = format("k8s-%s-%s", var.name_prefix, data.azurerm_resource_group.cluster.location)
  location            = data.azurerm_resource_group.cluster.location
  resource_group_name = data.azurerm_resource_group.cluster.name
  dns_prefix          = var.name_prefix

  # If kubernetes version is specified, we will attempt to use that
  # If not specified, use the latest non-preview version available in AKS
  kubernetes_version  = local.kubernetes_version

  default_node_pool {
    name       = var.default_node_pool.name
    vm_size    = var.default_node_pool.vm_size
    node_count = var.default_node_pool.node_count
  }

  service_principal {
    client_id     = azuread_service_principal.cluster.application_id
    client_secret = random_password.cluster.result
  }
}
##- Additional nodepools -##
resource "azurerm_kubernetes_cluster_node_pool" "additional_cluster" {
  for_each     = { for np in local.additional_node_pools : np.name => np }

  kubernetes_cluster_id = azurerm_kubernetes_cluster.cluster.id
  name                  = each.value.name
  vm_size               = each.value.vm_size
  node_count            = each.value.node_count

  tags = each.value.tags
}
