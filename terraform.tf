##- Terraform configuration & required providers -##
terraform {
  required_version = ">= 0.13"
  required_providers {
    azuread     = "0.11.0"
    azurerm     = "2.25.0"
    kubernetes  = "1.13.2"
  }
}

# Kubernetes provider
provider "kubernetes" {
  load_config_file = "false"

  host = azurerm_kubernetes_cluster.cluster.kube_admin_config.host

  client_certificate     = azurerm_kubernetes_cluster.cluster.kube_admin_config.client_certificate
  client_key             = azurerm_kubernetes_cluster.cluster.kube_admin_config.client_key
  cluster_ca_certificate = azurerm_kubernetes_cluster.cluster.kube_admin_config.cluster_ca_certificate
}