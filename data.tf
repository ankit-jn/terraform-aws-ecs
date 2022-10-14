data "aws_caller_identity" "current" {}

data "aws_ecs_cluster" "this" {

  count = !var.create_ecs_cluster ? 1 : 0

  cluster_name = var.cluster_name
}

data aws_service_discovery_dns_namespace "this" {

  count = !var.create_dns_namespace && var.enable_service_discovery ? 1 : 0

  name = var.dns_name
  type = "DNS_PRIVATE"
}

data aws_ssm_parameter "ecs_optimized_ami" {

  for_each = var.create_ecs_cluster ? { for asg in var.auto_scaling_groups : asg.name => asg } : {}
  name = lookup(each.value, "ssm_parameter_image", "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended")
}
