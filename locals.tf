locals {
  name          = var.name != null ? var.name : var.product
  bucket        = var.use_prefix ? null : local.name
  bucket_prefix = var.use_prefix ? "${local.name}-" : null

  create_replication_role = length(var.replication_configuration_set) != 0 || var.replication_configuration_shortcut != null
  replication_role        = local.create_replication_role ? aws_iam_role.replication_role[0].name : null

  replication_configuration_set = length(var.replication_configuration_set) != 0 ? var.replication_configuration_set : var.replication_configuration_shortcut == null ? toset([]) : toset([{
    role = aws_iam_role.replication_role[0].arn
    rules = [{
      id                                           = "${local.name}-replication_rule"
      priority                                     = 0
      status                                       = "Enabled"
      destination_account_id                       = var.replication_configuration_shortcut.destination_account_id
      destination_bucket                           = var.replication_configuration_shortcut.destination_bucket
      destination_access_control_translation_owner = "Destination"
    }]
    }
  ])

  generate_bucket_policy = var.bucket_policy == null && (var.allow_anonymous_vpce_access || local.create_replication_target_policy)

  create_bucket_policy = var.bucket_policy != null || local.generate_bucket_policy

  bucket_policy = var.bucket_policy != null ? var.bucket_policy : local.generate_bucket_policy ? data.aws_iam_policy_document.bucket_policy_doc[0].json : null

  create_replication_target_policy = var.replication_source != null
  destination_bucket               = length(local.replication_configuration_set) == 0 ? null : tolist(tolist(local.replication_configuration_set)[0].rules)[0].destination_bucket

  object_ownership = var.acl != null ? "BucketOwnerPreferred" : "BucketOwnerEnforced"

  create_inventory_config = var.inventory_bucket != null
  inventory_bucket_prefix = "${data.aws_caller_identity.current.account_id}/${aws_s3_bucket.bucket.id}/"

  creator = "terraform"

  tags = merge(
    var.tags,
    {
      Name                                      = local.name
      "${var.organization}:billing:product"     = var.product
      "${var.organization}:billing:environment" = var.environment
      creator                                   = local.creator
      repo                                      = var.repo
    }
  )
}
