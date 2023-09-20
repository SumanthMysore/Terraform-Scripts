provider "azurerm" {
  features {}
}

# terraform {
#   backend "azurerm" {
#     resource_group_name   = "state-rg"
#     storage_account_name  = "tfstateremotebackend"
#     container_name        = "tfstate"
#     key                   = "hub-and-spoke.tfstate"
#   }
# }