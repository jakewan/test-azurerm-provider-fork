provider "azurerm" {
  alias = "official"
  features {}
}

provider "azurermcbsi" {
  alias = "azurermcbsi"
  features {}
}

resource "azurerm_resource_group" "foo" {
  name     = "rg-foo"
  location = "Central US"
}

module "jobs" {
  source = "./modules/stream-analytics"
  providers = {
    azurerm.official        = azurerm.official
    azurermcbsi.azurermcbsi = azurermcbsi.azurermcbsi
  }
  resource_group_name = azurerm_resource_group.foo.name
  location            = azurerm_resource_group.foo.location
}
