# Create CloudWatch group and log stream
resource aws_cloudwatch_log_group "this" {

    count = var.create_service_log_group ? 1 : 0

    name  = "/ecs/${var.cluster_name}/svc-${var.service_name}"

    retention_in_days = var.log_group_retention

    tags = merge(
      { "Name" = "logs-svc-${var.service_name}" },
      var.default_tags
    )
}

data template_file "container_def" {
    template = file("${path.module}/containers/container.json.tpl")

    vars = {
      name            = var.container_configurations.name
      image           = var.container_configurations.image
      container_port  = var.container_configurations.container_port
      host_port       = var.container_configurations.host_port

      cpu             = lookup(var.container_configurations, "cpu", 1024)
      memory          = lookup(var.container_configurations, "memory", 1024)
      
      region          = var.aws_region
      log_group       = var.create_service_log_group ? aws_cloudwatch_log_group.this[0].name : ""   
    }
}

## Create Task Definition
resource aws_ecs_task_definition "this" {

    family                     = "svc-${var.service_name}-task"
    network_mode               = var.service_task_network_mode
    pid_mode                   = var.service_task_pid_mode
    requires_compatibilities   = [var.use_fargate ? "FARGATE" : "EC2"]
    cpu                        = lookup(var.container_configurations, "cpu", 1024)
    memory                     = lookup(var.container_configurations, "memory", 1024)
    execution_role_arn         = var.ecs_task_execution_role_arn
    task_role_arn              = var.ecs_task_role_arn
    
    container_definitions    = data.template_file.container_def.rendered
    
    dynamic "volume" {
      for_each = var.service_volumes
  
      content {
        name      = volume.value.name
        host_path = lookup(volume.value, "host_path", null)
      }
    }
    
    tags = merge(
      { "Name" = "svc-${var.service_name}-task" },
      var.default_tags
    )

    lifecycle {
      create_before_destroy = true
    }
}

resource aws_ecs_service "this" {

  name            = var.service_name
  cluster         = var.cluster_arn
  task_definition = "${aws_ecs_task_definition.this.family}:${max("${aws_ecs_task_definition.this.revision}")}"
  desired_count   = var.service_desired_capacity
  launch_type     = var.use_fargate ? "FARGATE" : var.launch_type

  dynamic "service_registries" {
    for_each = var.enable_service_discovery ? [1] : []

    content {
        registry_arn = aws_service_discovery_service.this[0].arn
    }
  }

  tags = merge(
    { "Name" = "svc-${var.service_name}" },
    var.default_tags
  )
}
