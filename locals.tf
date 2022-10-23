locals {
    cluster_arn = var.create_ecs_cluster ? module.ecs_cluster[0].cluster_arn : data.aws_ecs_cluster.this[0].arn

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

    sg_ingress_rules = flatten([ for rule_key, rule in var.sg_rules :  rule if rule_key == "ingress" ])
    sg_egress_rules = flatten([ for rule_key, rule in var.sg_rules :  rule if rule_key == "egress" ])

    additional_sg = var.additional_sg != null ? var.additional_sg : []

    security_groups = (var.create_service && var.create_sg) ? concat([module.ecs_security_group[0].security_group_id], 
                                                                    local.additional_sg) : local.additional_sg
}