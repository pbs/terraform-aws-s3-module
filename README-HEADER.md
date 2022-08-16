# PBS TF S3 Module

## Installation

### Using the Repo Source

Use this URL for the source of the module. See the usage examples below for more details.

```hcl
github.com/pbs/terraform-aws-s3-module?ref=x.y.z
```

### Alternative Installation Methods

More information can be found on these install methods and more in [the documentation here](./docs/general/install).

## Usage

This module provisions an S3 bucket.

The bucket will be `AES256` encrypted, without the option to adjust that.

By default, the bucket will be versioned. This can be adjusted by using the `is_versioned` parameter.

If your use case requires adjusting the CORS configuration of the bucket, that is exposed through the `cors_rules` parameter.

Integrate this module like so:

```hcl
module "s3" {
  source = "github.com/pbs/terraform-aws-s3-module?ref=x.y.z"

  # Tagging Parameters
  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo

  # Optional Parameters
}
```

It is highly recommended that you integrate an inventory prefix when using this module.

Do this like so:

```hcl
module "s3" {
  source  = "../modules/s3"

  # Tagging Parameters
  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo

  # Optional Parameters
  inventory_bucket = var.inventory_bucket
}
```

## Adding This Version of the Module

If this repo is added as a subtree, then the version of the module should be close to the version shown here:

`x.y.z`

Note, however that subtrees can be altered as desired within repositories.

Further documentation on usage can be found [here](./docs).

Below is automatically generated documentation on this Terraform module using [terraform-docs][terraform-docs]

---

[terraform-docs]: https://github.com/terraform-docs/terraform-docs
