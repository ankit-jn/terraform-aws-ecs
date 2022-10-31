output "service_arn" {
    description = "ARN of ECS Service"
    value       = aws_ecs_service.this.id
}

output "task_definition_arn" {
    description = "Full ARN of the Task Definition"
    value       = aws_ecs_task_definition.this.arn
}

output "service_log_group_name" {
    description = "Name of the Cloudwatch log Group for ECS Service"
    value       = var.create_log_group ? aws_cloudwatch_log_group.this[0].name : ""
}

output "service_log_group_arn" {
    description = "ARN of the Cloudwatch log Group for ECS Service"
    value       = var.create_log_group ? aws_cloudwatch_log_group.this[0].arn : ""
}

output "servcie_discovery_id" {
    description = "ID of Service Discovery Private Namespace"
    value = var.enable_service_discovery ? aws_service_discovery_service.this[0].id : ""
}

output "servcie_discovery_arn" {
    description = "ARN of Service Discovery Private Namespace"
    value = var.enable_service_discovery ? aws_service_discovery_service.this[0].arn : ""
}