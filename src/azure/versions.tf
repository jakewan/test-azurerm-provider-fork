terraform {
  backend "local" {

  }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.53.0"
    }
    azurerm-cbsi = {
      source  = "cbsinteractive/azurerm"
      version = "2.54.0"
    }
  }
}
