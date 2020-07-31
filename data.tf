######################
##-- DATA SOURCES --##
######################

##- Resource group that AKS will be deployed to -##
data "azurerm_resource_group" "cluster" {
  name = var.resource_group
}
##- Fetching the current verson of AKS
data "azurerm_kubernetes_service_versions" "current" {
  location = "West Europe"
}

output "versions" {
  value = data.azurerm_kubernetes_service_versions.current.versions
}

output "latest_version" {
  value = data.azurerm_kubernetes_service_versions.current.latest_version
}