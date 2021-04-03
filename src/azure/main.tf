provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "foo" {
  name     = "rg-foo"
  location = "Central US"
}

module "jobs" {
  source              = "./modules/stream-analytics"
  resource_group_name = azurerm_resource_group.foo.name
  location            = azurerm_resource_group.foo.location
}

resource "azurerm_stream_analytics_job" "bar" {
  name                 = "asa-job-bar"
  resource_group_name  = azurerm_resource_group.foo.name
  location             = azurerm_resource_group.foo.location
  compatibility_level = "1.1"
  streaming_units      = 120
  transformation_query = "bar query"
}
