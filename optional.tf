variable "name" {
  description = "Name to use for the bucket. If null, will default to product."
  default     = null
  type        = string
}

variable "use_prefix" {
  description = "Create bucket with prefix instead of explicit name"
  default     = true
  type        = bool
}

variable "is_versioned" {
  description = "Is versioning enabled?"
  default     = true
  type        = bool
}

variable "acl" {
  description = "Canned ACL for the bucket. If an ACL is not provided, the bucket will be created with ACLs disabled"
  default     = null
  type        = string
}

variable "force_destroy" {
  description = "Allow destruction of an S3 bucket without clearing out the contents first"
  default     = false
  type        = bool
}

variable "cors_rules" {
  description = "CORS Rules"
  default     = []
  type = set(object({
    allowed_headers = list(string),
    allowed_methods = list(string),
    allowed_origins = list(string),
    expose_headers  = list(string),
    max_age_seconds = number
  }))
}

variable "lifecycle_rules" {
  description = "List of maps containing configuration of object lifecycle management."
  type        = any
  default = [{
    id                                     = "default-lifecycle-rule",
    enabled                                = true,
    abort_incomplete_multipart_upload_days = 7,

    transition = [
      {
        days          = 7,
        storage_class = "INTELLIGENT_TIERING",
      }
    ]

    noncurrent_version_transition = [
      {
        days          = 30,
        storage_class = "GLACIER",
      }
    ]
  }]

  # Example:
  #
  # lifecycle_rules = [
  #   {
  #     id      = "log"
  #     enabled = true
  #
  #     prefix = "log/"
  #
  #     tags = {
  #       "rule"      = "log"
  #       "autoclean" = "true"
  #     }
  #
  #     transition = [
  #       {
  #         days          = 30
  #         storage_class = "STANDARD_IA" # or "ONEZONE_IA"
  #       },
  #       {
  #         days          = 60
  #         storage_class = "GLACIER"
  #       }
  #     ]
  #
  #     expiration = {
  #       days = 90
  #     }
  #   }
  # ]
}

variable "replication_configuration_set" {
  description = "Set of (single) replication that needs to be managed by this bucket. If empty, no replication takes place."
  default     = []
  type = set(object({
    role = string,
    rules = set(object({
      id                                           = string
      priority                                     = number
      status                                       = string
      destination_account_id                       = string
      destination_bucket                           = string
      destination_access_control_translation_owner = string
    }))
  }))
}

variable "replication_configuration_shortcut" {
  description = "Shorthand version of the configuration used in replication_configuration_set. Is overridden by replication_configuration_set if defined."
  default     = null
  type = object({
    destination_account_id = string
    destination_bucket     = string
  })
}

variable "replication_source" {
  description = "The account number and role for the source bucket in a replication configuration. Creates a bucket policy."
  default     = null
  type = object({
    account_id = string
    role       = string
  })
}

variable "bucket_policy" {
  description = "Policy to apply to the bucket. If null, one will be guessed based on surrounding functionality"
  default     = null
  type        = string
}

variable "allow_anonymous_vpce_access" {
  description = "Create bucket policy that allows anonymous VPCE access. If bucket_policy is defined, this will be ignored."
  default     = false
  type        = bool
}

variable "vpce" {
  description = "Name of the VPC endpoint that should have access to this bucket. Only used when `allow_anonymous_vpce_access` is true."
  default     = null
  type        = string
}

variable "inventory_bucket" {
  description = "Name of the bucket to use for inventory. If null, will not configure inventory configurations."
  default     = null
  type        = string
}

variable "inventory_frequency" {
  description = "Frequency of inventory collection."
  default     = "Daily"
  type        = string
}

variable "inventory_included_object_versions" {
  description = "Included object versions for inventory collection."
  default     = "All"
  type        = string
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  default     = true
  type        = bool
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  default     = true
  type        = bool
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  default     = true
  type        = bool
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  default     = true
  type        = bool
}

variable "force_tls" {
  description = "Deny HTTP requests that are made to the bucket without TLS."
  default     = true
  type        = bool
}
