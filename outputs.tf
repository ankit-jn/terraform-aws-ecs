output "ecs_cluster_arn" {
  description = "The ID/ARN of the ECS cluster"
  value       = local.ecs_cluster_arn
}

output "asg" {
  description = "The ID/ARN of the ECS cluster"
  value = { for key, asg in module.asg : key => asg.arn }
}

output "ecs_task_role" {
    description = "IAM Role for ECS Task with trusted Entity - ECS Task Service"
    value = module.iam_ecs_task.service_linked_roles["ecs-task"]
}

output "ecs_task_execution_role" {
    description = "IAM Role for ECS Task Exeution with trusted Entity - ECS Task Service"
    value = module.iam_ecs_task.service_linked_roles["ecs-task-execution"]
}