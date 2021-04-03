provider "azurerm" {
  alias = "official"
  features {}
}

provider "azurermcbsi" {
  alias = "azurermcbsi"
  features {}
}

resource "azurerm_stream_analytics_job" "foo" {
  name                 = "asa-job-foo"
  provider             = azurermcbsi.azurermcbsi
  resource_group_name  = var.resource_group_name
  location             = var.location
  streaming_units      = 192
  transformation_query = "foo query"
}

resource "azurerm_stream_analytics_job" "bar" {
  name                 = "asa-job-bar"
  provider             = azurerm.official
  resource_group_name  = var.resource_group_name
  location             = var.location
  streaming_units      = 192
  transformation_query = "bar query"
}
