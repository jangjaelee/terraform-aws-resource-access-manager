output "ram_resource_share_id" {
  value = element(concat(aws_ram_resource_share.this.*.id, [""]), 0)
}

output "ram_resource_share_tags_all" {
  value = element(concat(aws_ram_resource_share.this.*.tags_all, [""]), 0)
}