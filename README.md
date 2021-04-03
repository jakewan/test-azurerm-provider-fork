# Mixing Terraform Official and Community Providers Within a Module

Suppose that you use Terraform modules to subdivide your infrastructure code in some way. Further suppose that an official Hashicorp provider doesn't support the latest features that your use case requires for a particular resource type. What now? It's reasonable to assume that a badass utility like Terraform allows you to specify a community provider at the resource level inside a module, right?

Well, it might not be abundantly clear from the official documentation (as I write this), but...

## It Does, It Really Does

This repository contains an example that seems to work. Just ignore any suggesting that modules shouldn't be too stronghanded about the context in which they are instantiated, and boldly provide a `terraform` block specifying crazy stuff like this:

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
