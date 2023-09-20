resource "azurerm_resource_group" "test-rg" {
  name     = var.resource_group.name
  location = var.resource_group.location
  tags = {
    "Creator" = "Sumanth Mysore"
  }
}