output "service_log_group_name" {
    description = "Name of the Cloudwatch log Group for ECS Service"
    value       = var.create_service_log_group ? aws_cloudwatch_log_group.this[0].name : ""
}

output "service_log_group_arn" {
    description = "ARN of the Cloudwatch log Group for ECS Service"
    value       = var.create_service_log_group ? aws_cloudwatch_log_group.this[0].arn : ""
}

output "servcie_discovery_id" {
    description = "ID of Service Discovery Private Namespace"
    value = var.enable_service_discovery ? aws_service_discovery_service.this[0].id : ""
}

output "servcie_discovery_arn" {
    description = "ARN of Service Discovery Private Namespace"
    value = var.enable_service_discovery ? aws_service_discovery_service.this[0].arn : ""
}