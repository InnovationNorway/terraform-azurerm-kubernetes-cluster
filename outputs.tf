output "kube_config" {
  value = {
    host                   = base64decode(azurerm_kubernetes_cluster.main.kube_admin_config.0.host)
    client_certificate     = base64decode(azurerm_kubernetes_cluster.main.kube_admin_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.main.kube_admin_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.main.kube_admin_config.0.cluster_ca_certificate)
  }
  sensitive   = true
  description = "A kubeconfig.t"
}
