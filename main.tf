module "ecs_cluster" {
    source = "./cluster"

    count = var.create_ecs_cluster ? 1 : 0

    cluster_name    = var.ecs_cluster_name
    use_fargate     = var.use_fargate

    enable_cloudwatch_container_insights = var.enable_cloudwatch_container_insights

    enable_execute_command_configuration = var.enable_execute_command_configuration
    execute_command_configurations = var.execute_command_configurations

    fargate_capacity_providers = var.fargate_capacity_providers
    autoscaling_capacity_providers = local.autoscaling_capacity_providers
    
    default_tags = var.default_tags
}

module "asg" {
    for_each = var.create_ecs_cluster ? {for asg in var.auto_scaling_groups : asg.name => asg } : {}

    source = "git::https://github.com/arjstack/terraform-aws-asg.git"
    
    name = each.key
    
}

# ECS Task Roles
module "iam_ecs_task" {
    source = "git::https://github.com/arjstack/terraform-aws-iam.git"
    
    policies = concat(var.ecs_task_policies, var.ecs_task_execution_policies)
    service_linked_roles    = local.ecs_task_roles
}