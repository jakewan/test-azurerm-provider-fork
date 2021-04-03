provider "azurerm" {
  features {}
}

provider "azurermcbsi" {
  features {}
}

resource "azurermcbsi_stream_analytics_job" "foo" {
  name                 = "asa-job-foo"
  resource_group_name  = var.resource_group_name
  location             = var.location
  streaming_units      = 192
  transformation_query = "foo query"
}

resource "azurerm_stream_analytics_job" "bar" {
  name                 = "asa-job-bar"
  resource_group_name  = var.resource_group_name
  location             = var.location
  streaming_units      = 192
  transformation_query = "bar query"
}
