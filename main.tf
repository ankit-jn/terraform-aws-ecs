module "ecs_cluster" {
    source = "./cluster"

    count = var.create_ecs_cluster ? 1 : 0

    cluster_name    = var.cluster_name
    use_fargate     = var.use_fargate

    enable_cloudwatch_container_insights = var.enable_cloudwatch_container_insights

    enable_execute_command_configuration = var.enable_execute_command_configuration
    execute_command_configurations = var.execute_command_configurations

    fargate_capacity_providers = var.fargate_capacity_providers
    autoscaling_capacity_providers = local.autoscaling_capacity_providers

    default_tags = var.default_tags

    depends_on = [
        module.asg
    ]
}

## Auto Scaling Groups for Capacity Providers
module "asg" {
    for_each = var.create_ecs_cluster ? {for asg in var.auto_scaling_groups : asg.name => asg } : {}

    source = "git::https://github.com/arjstack/terraform-aws-asg.git?ref=development"
    
    name = each.key
    create_instance_profile = lookup(each.value, "create_instance_profile", false)
    min_size = each.value.min_size
    max_size = each.value.max_size
    vpc_zone_identifier = each.value.vpc_zone_identifier
    instance_type = each.value.instance_type
    image_id = jsondecode(data.aws_ssm_parameter.ecs_optimized_ami[each.key].value)["image_id"]
}


# ECS Task Roles
module "iam_ecs_task" {
    source = "git::https://github.com/arjstack/terraform-aws-iam.git"
    
    policies = concat(var.ecs_instance_policies, var.ecs_task_policies, var.ecs_task_execution_policies)
    service_linked_roles    = concat(local.ecs_instance_roles, local.ecs_task_roles)
}

## ECS Service
module "ecs_service" {
    source = "./service"
    
    aws_region = var.aws_region

    cluster_name = var.cluster_name
    service_name = var.service_name
    
    use_fargate  = var.use_fargate
    
    service_task_network_mode   = var.service_task_network_mode
    service_task_pid_mode       = var.service_task_pid_mode
    
    service_volumes = var.service_volumes
    
    container_configurations = var.container_configurations

    ecs_task_execution_role_arn = module.iam_ecs_task.service_linked_roles["ecs-task-execution"].arn
    ecs_task_role_arn           = module.iam_ecs_task.service_linked_roles["ecs-task"].arn
    
    create_service_log_group    = var.create_service_log_group
    log_group_retention         = var.log_group_retention

    default_tags = var.default_tags
}