output "ecs_cluster_arn" {
  description = "The ID/ARN of the ECS cluster"
  value       = local.ecs_cluster_arn
}

output "asg" {
  description = "The ID/ARN of the ECS cluster"
  value = { for key, asg in module.asg : key => asg.arn }
}

