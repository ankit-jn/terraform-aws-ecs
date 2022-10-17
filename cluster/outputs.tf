output "cluster_arn" {
  description = "The ID/ARN of the ECS cluster"
  value       = aws_ecs_cluster.this.arn
}
