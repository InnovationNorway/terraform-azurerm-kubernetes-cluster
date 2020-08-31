##-- DATA SOURCES --##

## Resource group that AKS will be deployed to
data "azurerm_resource_group" "cluster" {
  name = var.resource_group
}
## Fetching the current verson of AKS
data "azurerm_kubernetes_service_versions" "current" {
  location = "West Europe"
  include_preview = false
}
## The subnet that the cluster will use
data "azurerm_subnet" "cluster" {
  name                 = var.subnet[0].subnet_name
  virtual_network_name = var.subnet[0].vnet_name
  resource_group_name  = var.subnet[0].resource_group_name
}
## Log analytics workspace
data "azurerm_log_analytics_workspace" "westeurope" {
  name                = "core-sh-mon-pwe-law"
  resource_group_name = "core-sh-mon-pwe-rg"
}