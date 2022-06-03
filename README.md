# PBS TF s3 module

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

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.replication_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.replication_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_s3_bucket.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_cors_configuration.cors_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource |
| [aws_s3_bucket_inventory.inventory_prefix](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_inventory) | resource |
| [aws_s3_bucket_lifecycle_configuration.lifecycle_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_ownership_controls.ownership_controls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_replication_configuration.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.bucket_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (sharedtools, dev, staging, prod) | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | Organization using this module. Used to prefix tags so that they are easily identified as being from your organization | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | Tag used to group resources according to product | `string` | n/a | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | Tag used to point to the repo using this module | `string` | n/a | yes |
| <a name="input_acl"></a> [acl](#input\_acl) | Canned ACL for the bucket. If an ACL is not provided, the bucket will be created with ACLs disabled | `string` | `null` | no |
| <a name="input_allow_anonymous_vpce_access"></a> [allow\_anonymous\_vpce\_access](#input\_allow\_anonymous\_vpce\_access) | Create bucket policy that allows anonymous VPCE access. If bucket\_policy is defined, this will be ignored. | `bool` | `false` | no |
| <a name="input_bucket_policy"></a> [bucket\_policy](#input\_bucket\_policy) | Policy to apply to the bucket. If null, one will be guessed based on surrounding functionality | `string` | `null` | no |
| <a name="input_cors_rules"></a> [cors\_rules](#input\_cors\_rules) | CORS Rules | <pre>set(object({<br>    allowed_headers = list(string),<br>    allowed_methods = list(string),<br>    allowed_origins = list(string),<br>    expose_headers  = list(string),<br>    max_age_seconds = number<br>  }))</pre> | `[]` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Allow destruction of an S3 bucket without clearing out the contents first | `bool` | `false` | no |
| <a name="input_inventory_bucket"></a> [inventory\_bucket](#input\_inventory\_bucket) | Name of the bucket to use for inventory. If null, will not configure inventory configurations. | `string` | `null` | no |
| <a name="input_inventory_frequency"></a> [inventory\_frequency](#input\_inventory\_frequency) | Frequency of inventory collection. | `string` | `"Daily"` | no |
| <a name="input_inventory_included_object_versions"></a> [inventory\_included\_object\_versions](#input\_inventory\_included\_object\_versions) | Included object versions for inventory collection. | `string` | `"All"` | no |
| <a name="input_is_versioned"></a> [is\_versioned](#input\_is\_versioned) | Is versioning enabled? | `bool` | `true` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | List of maps containing configuration of object lifecycle management. | `any` | <pre>[<br>  {<br>    "abort_incomplete_multipart_upload_days": 7,<br>    "enabled": true,<br>    "id": "default-lifecycle-rule",<br>    "noncurrent_version_transition": [<br>      {<br>        "days": 30,<br>        "storage_class": "GLACIER"<br>      }<br>    ],<br>    "transition": [<br>      {<br>        "days": 7,<br>        "storage_class": "INTELLIGENT_TIERING"<br>      }<br>    ]<br>  }<br>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Name to use for the bucket. If null, will default to product. | `string` | `null` | no |
| <a name="input_replication_configuration_set"></a> [replication\_configuration\_set](#input\_replication\_configuration\_set) | Set of (single) replication that needs to be managed by this bucket. If empty, no replication takes place. | <pre>set(object({<br>    role = string,<br>    rules = set(object({<br>      id                                           = string<br>      priority                                     = number<br>      status                                       = string<br>      destination_account_id                       = string<br>      destination_bucket                           = string<br>      destination_access_control_translation_owner = string<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_replication_configuration_shortcut"></a> [replication\_configuration\_shortcut](#input\_replication\_configuration\_shortcut) | Shorthand version of the configuration used in replication\_configuration\_set. Is overridden by replication\_configuration\_set if defined. | <pre>object({<br>    destination_account_id = string<br>    destination_bucket     = string<br>  })</pre> | `null` | no |
| <a name="input_replication_source"></a> [replication\_source](#input\_replication\_source) | The account number and role for the source bucket in a replication configuration. Creates a bucket policy. | <pre>object({<br>    account_id = string<br>    role       = string<br>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Extra tags | `map(string)` | `{}` | no |
| <a name="input_use_prefix"></a> [use\_prefix](#input\_use\_prefix) | Create bucket with prefix instead of explicit name | `bool` | `true` | no |
| <a name="input_vpce"></a> [vpce](#input\_vpce) | Name of the VPC endpoint that should have access to this bucket. Only used when `allow_anonymous_vpce_access` is true. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the bucket |
| <a name="output_name"></a> [name](#output\_name) | Name of the bucket |
| <a name="output_regional_domain_name"></a> [regional\_domain\_name](#output\_regional\_domain\_name) | Regional domain name |
| <a name="output_replication_role"></a> [replication\_role](#output\_replication\_role) | Replication role if exists |
