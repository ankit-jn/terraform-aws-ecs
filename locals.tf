locals {
  ecs_cluster_arn = var.create_ecs_cluster ? module.ecs_cluster[0].cluster_arn : data.aws_ecs_cluster.this[0].arn

  autoscaling_capacity_providers = {for capacity_provider_key, capacity_provider_config in var.autoscaling_capacity_providers: 
                                      capacity_provider_key => merge(
                                                                    capacity_provider_config, 
                                                                    { asg_arn = module.asg[capacity_provider_key].arn })}
}