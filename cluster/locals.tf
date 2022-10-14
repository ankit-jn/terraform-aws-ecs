locals {
    fargate_capacity_provider_names = toset([for k, v in var.fargate_capacity_providers: k])
    
    autoscaling_capacity_provider_names = toset([for k, v in var.autoscaling_capacity_providers: k])

    capacity_providers = merge(
        {for k, v in var.fargate_capacity_providers: k=>v if var.use_fargate},
        {for k, v in var.autoscaling_capacity_providers: k=>v if !var.use_fargate}
      )

    capacity_provider_names = toset([for k, v in local.capacity_providers: k])
}