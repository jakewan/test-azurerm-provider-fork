terraform {
  required_providers {
    azurerm-forked = {
      source  = "cbsinteractive/azurerm"
      version = "2.55.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.53.0"
    }
  }
}
