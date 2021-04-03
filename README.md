# Test AzureRM Provider Fork

Status of this project: Work in progress

Due to https://github.com/jakewan/test-azurerm-provider-fork/issues/1, Terraform can successfully generate a plan to build an Azure Stream Analytics job with compatibility level 1.2, but the `apply` fails. This is due to the naive approach I took to add the missing feature. The error reported by the API offers the correct solution. Until I've had a chance to follow-up on that, **this project is broken**.

## Mixing an official Terraform provider and a community provider of the same type within a child module

This project demonstrates a solution for the following use case:

1. You use Terraform modules to subdivide your infrastructure code in some way.
2. An official Terraform provider doesn't support the latest features that your use case requires for a particular resource type.
3. You have chosen to fork the Terraform provider to obtain the missing functionality. Based on the fork, you have published a community provider in the [Terraform Registry](https://registry.terraform.io).
4. The resource that you want managed by the community provider resides inside a child module.
5. Within the same child module, there are other resources that should remain managed by the official provider.

The solution comes from two different places in the documentation:

* [Provider Version Constraints in Modules](https://www.terraform.io/docs/language/modules/develop/providers.html#provider-version-constraints-in-modules) explains that a child module should include its own `terraform` configuration block containing a `required_providers` block to specify the desired provider versions.
* [Handling Local Name Conflicts](https://www.terraform.io/docs/language/providers/requirements.html#handling-local-name-conflicts) explains how to use two different providers of the same "type".

For example, in module/versions.tf:

```hcl
terraform {
  required_providers {
    someservice-forked = {
      source  = "my-own/someservice"
      version = "1.2.3"
    }
    someservice = {
      source  = "hashicorp/someservice"
      version = "2.53.0"
    }
  }
}
```

In module/main.tf:

```hcl
provider "someservice" {
  features {}
}

provider "someservice-forked" {
  features {}
}

// my-own/someservice lets us access this new setting
resource "someservice_some_resource" "foo" {
  name                 = "some-foo"
  provider             = someservice-forked
  new_feature_setting  = "This is new!"
}

// Uses the official provider because we don't require bleeding-edge
// features that it doesn't support yet.
resource "someservice_some_resource" "bar" {
  name                 = "some-bar"
  provider             = someservice
}
```

## This Repository

This repository presents an example of this particular use case being met based on the configuration prototype presented above.

The root module specifies an Azure resource group named `rg-foo` and instantiates a module labeled `jobs`, passing it the name of that resource group and its location. It does not pass any information about the provider(s) that should be used to manage resource defined inside the module.

Within the child module, there are two Azure Stream Analytics job configurations. One uses compatibility level 1.1 and the other uses compatibility level 1.2. Since compatibility level 1.2 is not currently supported by the official provider, we use a community provider with support for compatibility level 1.2 to manage *only* the resource that requires it.
