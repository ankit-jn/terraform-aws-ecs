locals {
    ecs_cluster_arn = var.create_ecs_cluster ? module.ecs_cluster[0].cluster_arn : data.aws_ecs_cluster.this[0].arn

    namespace_id = var.create_dns_namespace ? aws_service_discovery_private_dns_namespace.this[0].id : try(data.aws_service_discovery_dns_namespace.this[0].id, "")
    namespace_arn = var.create_dns_namespace ? aws_service_discovery_private_dns_namespace.this[0].arn : try(data.aws_service_discovery_dns_namespace.this[0].arn, "")
   
    ecs_task_roles = [                
                        {
                            name = "ecs-task"
                            description = "IAM Role for ECS Task with trusted Entity - ECS Task Service"
                            service_names = [
                                "ecs-tasks.amazonaws.com"
                            ]
                            policy_list =  var.ecs_task_policies            
                        },
                        {
                            name = "ecs-task-execution"
                            description = "IAM Role for ECS Task Exeution with trusted Entity - ECS Task Service"
                            service_names = [
                                "ecs-tasks.amazonaws.com"
                            ]  
                            policy_lisy = var.ecs_task_execution_policies      
                        }
                    ]

    service_sg_ingress_rules = flatten([ for rule_key, rule in var.service_sg_rules :  rule if rule_key == "ingress" ])
    service_sg_egress_rules = flatten([ for rule_key, rule in var.service_sg_rules :  rule if rule_key == "egress" ])

    service_additional_sg = var.service_additional_sg != null ? var.service_additional_sg : []

    service_security_groups = var.create_service_sg ? concat([module.ecs_security_group[0].security_group_id], 
                                                                    local.service_additional_sg) : local.service_additional_sg
}