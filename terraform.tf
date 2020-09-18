##- Terraform configuration & required providers -##
terraform {
  required_version = ">= 0.13"
  required_providers {
    azuread = "0.11.0"
    azurerm = "2.25.0"
  }
}