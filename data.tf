######################
##-- DATA SOURCES --##
######################

##- Resource group that AKS will be deployed to -##
data "azurerm_resource_group" "cluster" {
  name = var.resource_group
}