provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "foo" {
  name     = "rg-foo"
  location = "Central US"
}

module "jobs" {
  source = "./modules/stream-analytics"
  resource_group_name = azurerm_resource_group.foo.name
  location            = azurerm_resource_group.foo.location
}
