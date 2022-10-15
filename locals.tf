locals {
    ecs_cluster_arn = var.create_ecs_cluster ? module.ecs_cluster[0].cluster_arn : data.aws_ecs_cluster.this[0].arn

    namespace_id = var.create_dns_namespace ? aws_service_discovery_private_dns_namespace.this[0].id : try(data.aws_service_discovery_dns_namespace.this[0].id, "")
    namespace_arn = var.create_dns_namespace ? aws_service_discovery_private_dns_namespace.this[0].arn : try(data.aws_service_discovery_dns_namespace.this[0].arn, "")

    ecs_instance_profiles = {for profile in var.ecs_instance_profiles : 
                                            profile.asg_name => profile }
    
    ecs_instance_profile_policies = {for profile in var.ecs_instance_profiles : 
                                            profile.asg_name => [ for policy_name in profile.policies: 
                                                                                    module.iam_ecs.policies[policy_name].arn ] }
    autoscaling_capacity_providers = {for capacity_provider in var.autoscaling_capacity_providers: 
                                        capacity_provider.name => merge(
                                                                    capacity_provider, 
                                                                    { asg_arn = lookup(capacity_provider, "asg_arn", "") != "" ? capacity_provider.asg_arn: module.asg[capacity_provider.asg_name].arn })}

    ecs_task_roles = [                
                        {
                            name = "ecs-task"
                            description = "IAM Role for ECS Task with trusted Entity - ECS Task Service"
                            service_names = [
                                "ecs-tasks.amazonaws.com"
                            ]
                            policy_map = {
                                policy_names= var.ecs_task_policies
                            }                  
                        },
                        {
                            name = "ecs-task-execution"
                            description = "IAM Role for ECS Task Exeution with trusted Entity - ECS Task Service"
                            service_names = [
                                "ecs-tasks.amazonaws.com"
                            ]  
                            policy_map = {
                                policy_names = var.ecs_task_execution_policies
                            }                   
                        }
                    ]

    service_sg_ingress_rules = flatten([ for rule_key, rule in var.service_sg_rules :  rule if rule_key == "ingress" ])
    service_sg_egress_rules = flatten([ for rule_key, rule in var.service_sg_rules :  rule if rule_key == "egress" ])

    service_additional_sg = var.service_additional_sg != null ? var.service_additional_sg : []

    service_security_groups = var.create_service_sg ? concat([module.ecs_security_group[0].security_group_id], 
                                                                    local.service_additional_sg) : local.service_additional_sg
}