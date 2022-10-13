data "aws_ecs_cluster" "this" {

  count = !var.create_ecs_cluster ? 1 : 0

  cluster_name = var.cluster_name
}