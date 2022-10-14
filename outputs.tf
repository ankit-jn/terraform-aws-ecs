output "ecs_cluster_arn" {
  description = "The ID/ARN of the ECS cluster"
  value       = local.ecs_cluster_arn
}

output "asg" {
  description = "Details of ASGs for Capacity Providers"
  value = { for key, asg in module.asg : 
              key => {
                        arn = asg.arn 
                        launch_template = asg.launch_template
                        instance_profile_arn = asg.instance_profile_arn
                        instance_profile_role_arn = asg.instance_profile_role_arn
                    }}
}

output "ecs_task_role" {
    description = "IAM Role for ECS Task with trusted Entity - ECS Task Service"
    value = module.iam_ecs_task.service_linked_roles["ecs-task"]
}

output "ecs_task_execution_role" {
    description = "IAM Role for ECS Task Exeution with trusted Entity - ECS Task Service"
    value = module.iam_ecs_task.service_linked_roles["ecs-task-execution"]
}

output "ecs_service_log_group_name" {
    description = "Name of the Cloudwatch log Group for ECS Service"
    value       = module.ecs_service.service_log_group_name
}

output "ecs_service_log_group_arn" {
    description = "ARN of the Cloudwatch log Group for ECS Service"
    value       = module.ecs_service.service_log_group_arn
}

output "servcie_discovery_namespace_id" {
    description = "ID of Service Discovery Private Namespace"
    value = local.namespace_id
}

output "servcie_discovery_namespace_arn" {
    description = "ARN of Service Discovery Private Namespace"
    value = local.namespace_arn
}

output "servcie_discovery_id" {
    description = "ID of Service Discovery"
    value = module.ecs_service.servcie_discovery_id
}

output "servcie_discovery_arn" {
    description = "ARN of Service Discovery"
    value = module.ecs_service.servcie_discovery_arn
}