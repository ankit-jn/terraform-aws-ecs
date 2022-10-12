#### Provision ECS Cluster
resource aws_ecs_cluster "this" {
  count = var.create_ecs_cluster ? 1 : 0

  name = var.ecs_cluster_name

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
        kms_key_id = try(var.execute_command_configurations.kms_key_id, null)
        logging    = try(var.execute_command_configurations.logging, "DEFAULT")
        
        # Logging Configuration for redirecting the log for Execute command results
        dynamic "log_configuration" {
              for_each = try([var.execute_command_configurations.log_configuration], {})

              content {
                cloud_watch_encryption_enabled = try(log_configuration.value.cloud_watch_encryption_enabled, null)
                cloud_watch_log_group_name     = try(log_configuration.value.cloud_watch_log_group_name, null)
                s3_bucket_name                 = try(log_configuration.value.s3_bucket_name, null)
                s3_bucket_encryption_enabled   = try(log_configuration.value.s3_bucket_encryption_enabled, null)
                s3_key_prefix                  = try(log_configuration.value.s3_key_prefix, null)
              }
            }
      }
    }
  }

  tags = merge(
    { "Name" = format("%s", var.ecs_cluster_name) },
    var.default_tags
  )
}
