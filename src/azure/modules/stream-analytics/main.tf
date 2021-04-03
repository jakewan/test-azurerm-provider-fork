provider "azurerm" {
  features {}
}

provider "azurerm-forked" {
  features {}
}

resource "azurerm_stream_analytics_job" "foo" {
  name                 = "asa-job-foo"
  provider             = azurerm-forked
  resource_group_name  = var.resource_group_name
  location             = var.location
  compatibility_level  = "1.2"
  streaming_units      = 192
  transformation_query = "foo query"
}

resource "azurerm_stream_analytics_job" "bar" {
  name                 = "asa-job-bar"
  provider             = azurerm
  resource_group_name  = var.resource_group_name
  location             = var.location
  compatibility_level  = "1.1"
  streaming_units      = 120
  transformation_query = "bar query"
}
