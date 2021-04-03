# Test AzureRM Provider Fork

Status of this project: Work in progress

Due to https://github.com/jakewan/test-azurerm-provider-fork/issues/1, the Terraform can successfully generate a plan to build an Azure Stream Analytics job with compatibility level 1.2, but it fails when you try to apply the changes. This is due to the naive approach I attempted to add the missing feature. The error reported by the API offers the correct solution. Until I've had a chance to follow-up on that, **this project is broken**.

## Mixing an official Terraform provider and a community provider of the same type within a child module

This project demonstrates a solution for the following use case:

1. You use Terraform modules to subdivide your infrastructure code in some way.
2. An official Terraform provider doesn't support the latest features that your use case requires for a particular resource type.
3. You have chosen to fork the Terraform provider to obtain the missing functionality. Based on the fork, you have published a community provider in the [Terraform Registry](https://registry.terraform.io).

Well, it might not be abundantly clear from the official documentation (as I write this), but...

## It Does, It Really Does

This repository contains an example that seems to work. Just ignore any suggestions that modules shouldn't be too stronghanded about the context in which they are instantiated. Boldly provide a `terraform` block specifying crazy stuff like this:

```hcl
terraform {
  required_providers {
    awesomeservice-forked = {
      source  = "my-own/awesomeservice"
      version = "1.2.3"
    }
    awesomeservice = {
      source  = "hashicorp/awesomeservice"
      version = "2.53.0"
    }
  }
}
```

Then, within the module's infrastructure code, you can do this:

```hcl
provider "awesomeservice" {
  features {}
}

provider "awesomeservice-forked" {
  features {}
}

// my-own/awesomeservice lets us access this new setting
resource "awesomeservice_badass_resource" "foo" {
  name                 = "asa-job-foo"
  provider             = awesomeservice-forked
  new_feature_setting  = "OMG this is new!"
}

resource "awesomeservice_badass_resource" "bar" {
  name                 = "asa-job-bar"
  provider             = awesomeservice
}
```

# This Repository

This repository presents an example of this particular use case being met based on the configuration prototype presented above.

The root module specifies an Azure resource group named `rg-foo` and instantiates a module labeled `jobs`, passing it the name of that resource group and its location. It does not pass any information about the provider(s) that should be used to manage resource defined inside the module. This is the key point, because it _feels_ like Hashicorp intends for modules to require their consumers to provide all of the provider context at runtime. This example demonstrates behavior to the contrary.

The key ingredient seems to be that the module includes its own `terraform` block, where the official and unofficial providers of the AzureRM provider are defined.
