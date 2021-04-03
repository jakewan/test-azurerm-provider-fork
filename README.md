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
