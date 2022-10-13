output "service_log_group_name" {
    description = "Name of the Cloudwatch log Group for ECS Service"
    value       = var.create_service_log_group ? aws_cloudwatch_log_group.this[0].name : ""
}

output "service_log_group_arn" {
    description = "ARN of the Cloudwatch log Group for ECS Service"
    value       = var.create_service_log_group ? aws_cloudwatch_log_group.this[0].arn : ""
}