resource "null_resource" "validate_module_name" {
  count = local.module_name == var.tags["TerraformModuleName"] ? 0 : "Please check that you are using the Terraform module"
}

resource "null_resource" "validate_module_version" {
  count = local.module_version == var.tags["TerraformModuleVersion"] ? 0 : "Please check that you are using the Terraform module"
}

resource "aws_ram_resource_share" "this" {
  count = var.create_ram ? 1 : 0

  name                      = var.ram_name
  allow_external_principals = var.allow_external_principals

  tags = merge(
    var.tags, tomap(
      {"Name" = format("%s-%s-ram", var.prefix, var.ram_name)}
    )
  ) 
}

resource "aws_ram_resource_association" "this" {
  count = var.create_ram ? 1 : 0

  resource_arn       = var.resource_arn
  resource_share_arn = aws_ram_resource_share.this[0].id
}

resource "aws_ram_principal_association" "this" {
  count = var.create_ram ? 1 : 0

  principal          = var.ram_principals[0]
  resource_share_arn = aws_ram_resource_share.this[0].id
}

resource "aws_ram_resource_share_accepter" "this" {
  count = !var.create_ram && var.share_accepter? 1 : 0

  share_arn = var.ram_resource_share_arn
}