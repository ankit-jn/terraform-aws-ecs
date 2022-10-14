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

    # source = "git::https://github.com/arjstack/terraform-aws-asg.git?ref=development"
    source = "../terraform-aws-asg"
    name = each.key
    
    min_size = each.value.min_size
    max_size = each.value.max_size
    vpc_zone_identifier = each.value.vpc_zone_identifier
    instance_type = each.value.instance_type
    image_id = jsondecode(data.aws_ssm_parameter.ecs_optimized_ami[each.key].value)["image_id"]

    create_instance_profile = lookup(each.value, "create_instance_profile", false)
    instance_profile_name = try(local.ecs_instance_profiles[each.key].profile_name, format("%s-instance-profile", each.key))
    instance_profile_path = try(local.ecs_instance_profiles[each.key].profile_path, "/")
    instance_profile_policies = try(local.ecs_instance_profiles[each.key].profile_role_policies, {})
    instance_profile_tags = try(local.ecs_instance_profiles[each.key].tags, {})

    default_tags = lookup(each.value, "tags", {})
}

# ECS Task Roles
module "iam_ecs_task" {
    source = "git::https://github.com/arjstack/terraform-aws-iam.git"
    
    policies = var.policies
    service_linked_roles    = local.ecs_task_roles
}

## Create Service Discovery Private DNS Namespace.
resource aws_service_discovery_private_dns_namespace "this" {
    count = var.create_dns_namespace ? 1 : 0
    
    name        = (var.dns_name != "") ? var.dns_name : format("%s.ecs.local", var.cluster_name)
    description = "Service Discovery Private DNS Namespace for ECS Cluster - ${var.cluster_name}"
    
    vpc         = var.vpc_id
}



## ECS Service
module "ecs_service" {
    source = "./service"
    
    aws_region = var.aws_region
    account_id = data.aws_caller_identity.current.account_id
    
    cluster_name = var.cluster_name
    cluster_arn  = local.ecs_cluster_arn
    
    service_name = var.service_name
    service_min_capacity = var.service_scalability.min_capacity
    service_max_capacity = var.service_scalability.max_capacity
    service_desired_capacity = var.service_scalability.desired_capacity
    
    use_fargate  = var.use_fargate
    launch_type = var.service_launch_type
    
    service_task_network_mode   = var.service_task_network_mode
    service_task_pid_mode       = var.service_task_pid_mode
    
    service_volumes = var.service_volumes
    
    container_configurations = var.container_configurations

    ecs_task_execution_role_arn = module.iam_ecs_task.service_linked_roles["ecs-task-execution"].arn
    ecs_task_role_arn           = module.iam_ecs_task.service_linked_roles["ecs-task"].arn
    
    create_service_log_group    = var.create_service_log_group
    log_group_retention         = var.log_group_retention

    enable_service_discovery    = var.enable_service_discovery
    namespace_id                = local.namespace_id

    default_tags = var.default_tags
}