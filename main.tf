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
    for_each = var.create_ecs ? var.auto_scaling_groups : {}

    source = "git::https://github.com/arjstack/terraform-aws-asg.git"

    # name = format("ecs_%s_cp_%s", var.ecs_cluster_name, lower(each.key))
    
}