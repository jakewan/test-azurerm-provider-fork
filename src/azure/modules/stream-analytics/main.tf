provider "azurerm" {
  features {}
}

resource "azurerm_stream_analytics_job" "foo" {
  name                 = "asa-job-foo"
  resource_group_name  = var.resource_group_name
  location             = var.location
  compatibility_level = "1.2"
  streaming_units      = 192
  transformation_query = "foo query"
}
