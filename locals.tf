locals {
  ecs_cluster_arn = var.create_ecs_cluster ? aws_ecs_cluster.this[0].arn : data.aws_ecs_cluster.this[0].arn
}