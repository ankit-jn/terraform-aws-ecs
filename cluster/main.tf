data aws_autoscaling_group "this" {
    for_each = {for k, v in local.autoscaling_capacity_providers: k=>v if (lookup(v, "asg_name", "") != "")}

    name = each.value.asg_name
}


#### Provision ECS Cluster
resource aws_ecs_cluster "this" {
  
  name = var.cluster_name

  # Cluster Setting: Enable CloudWatch Container Insights
  dynamic "setting" {
    for_each = var.enable_cloudwatch_container_insights ? [1] : []

    content {
      name  = "containerInsights"
      value = "enabled"
    }
  }

  # Cluster Configuration: The execute command configuration
  dynamic "configuration" {
    for_each = var.enable_execute_command_configuration ? [1] : []
    content {
      # Execute Command Configuration
      execute_command_configuration {
        kms_key_id = lookup(var.execute_command_configurations, "kms_key_id", null)
        logging    = lookup(var.execute_command_configurations, "logging", "DEFAULT")
        
        # Logging Configuration for redirecting the log for Execute command results
        dynamic "log_configuration" {
              for_each = [lookup(var.execute_command_configurations, "log_configuration", {})]

              content {
                cloud_watch_encryption_enabled = lookup(log_configuration.value, "cloudwatch_encryption_enabled", null)
                cloud_watch_log_group_name     = lookup(log_configuration.value, "cloudwatch_log_group_name", null)
                s3_bucket_name                 = lookup(log_configuration.value, "s3_bucket_name", null)
                s3_bucket_encryption_enabled   = lookup(log_configuration.value, "s3_bucket_encryption_enabled", null)
                s3_key_prefix                  = lookup(log_configuration.value, "s3_key_prefix", null)
              }
            }
      }
    }
  }

  tags = merge(
    { "Name" = format("%s", var.cluster_name) },
    var.default_tags
  )
}

## Manages the capacity providers of an ECS Cluster.
resource aws_ecs_cluster_capacity_providers "this" {
    cluster_name = var.cluster_name
    
    capacity_providers = local.capacity_provider_names
    
    dynamic default_capacity_provider_strategy {
        for_each = local.capacity_providers
        iterator = capacity_provider

        content {
            capacity_provider = capacity_provider.key
            weight = try(capacity_provider.value.default_strategy.weight, null)
            base = try(capacity_provider.value.default_strategy.base, null)
        }
    }

    depends_on = [
      aws_ecs_cluster.this,
      aws_ecs_capacity_provider.this
    ]
}

## Provision ASG Based Capacity Providers
## Not required to provision if ECS cluster is based on Fargate
resource aws_ecs_capacity_provider "this" {
    for_each = local.autoscaling_capacity_providers

    name = each.key
  
    auto_scaling_group_provider {
        auto_scaling_group_arn = (lookup(each.value, "asg_arn", "") != "") ? each.value.asg_arn : (
                                                                                    data.aws_autoscaling_group.this[each.value.name].arn)
        managed_termination_protection = lookup(each.value, "managed_termination_protection", null)

        dynamic "managed_scaling" {
          for_each = lookup(each.value, "configure_managed_scaling", false) ? [1] : []

          content {
            instance_warmup_period    = lookup(each.value, "instance_warmup_period", 300)
            maximum_scaling_step_size = lookup(each.value, "maximum_scaling_step_size", null)
            minimum_scaling_step_size = lookup(each.value, "minimum_scaling_step_size", null)
            status                    = lookup(each.value, "status", null)
            target_capacity           = lookup(each.value, "target_capacity", null)
          }
        }
    }

    tags = merge(
      { "Name" = format("ecs-%s-cp-%s", var.cluster_name, each.key) },
      var.default_tags,
      lookup(each.value, "tags", {})
    )
}