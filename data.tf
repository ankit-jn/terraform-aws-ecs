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

data aws_lb "this" {

    count = var.attach_load_balancer ? 1 : 0

    arn =  can(var.load_balancer_arn) && var.load_balancer_arn != "" ? var.load_balancer_arn : null
    name =  can(var.load_balancer_name) && var.load_balancer_name != "" ? var.load_balancer_name : null
}