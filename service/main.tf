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
      log_group       = var.create_log_group ? aws_cloudwatch_log_group.this[0].name : ""   
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
    
    container_definitions = coalesce(var.container_definition, data.template_file.container_def.rendered)
    
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
    desired_count   = var.desired_capacity
    launch_type     = var.use_fargate ? "FARGATE" : var.launch_type

    network_configuration {
        security_groups  = var.security_groups
        subnets          = var.subnets
        assign_public_ip = !var.use_fargate ? false : var.assign_public_ip
    }
    
    dynamic "service_registries" {
        for_each = var.enable_service_discovery ? [1] : []

        content {
            registry_arn = aws_service_discovery_service.this[0].arn
        }
    }

    dynamic "load_balancer" {
        for_each = var.attach_load_balancer ? var.load_balancer_configs : {}

        content {
            target_group_arn = data.aws_lb_target_group.this[load_balancer.key].arn
            container_name   = load_balancer.value.container_name
            container_port   = load_balancer.value.container_port
        }
    }

    tags = merge(
      { "Name" = "svc-${var.service_name}" },
      var.default_tags
    )
}

data aws_lb_target_group "this" {
  for_each = var.attach_load_balancer ? var.load_balancer_configs : {}

  name = each.value.target_group_name
}

locals{

}

# Create CloudWatch group and log stream
resource aws_cloudwatch_log_group "this" {

    count = var.create_log_group ? 1 : 0

    name  = "/ecs/${var.cluster_name}/svc-${var.service_name}"

    retention_in_days = var.log_group_retention

    tags = merge(
      { "Name" = "logs-svc-${var.service_name}" },
      var.default_tags
    )
}

