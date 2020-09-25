##- Terraform configuration & required providers -##
terraform {
  required_version = ">= 0.13"
  required_providers {
    azuread     = "0.11.0"
    azurerm     = "2.25.0"
    kubernetes  = "1.13.2"
  }
}

provider "kubernetes" {
  load_config_file = "false"

  host                   = azurerm_kubernetes_cluster.cluster.kube_config.0.host

  client_certificate     = base64decode(azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.cluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)
}