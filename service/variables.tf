variable "aws_region" {
  description = "THe region to use"
  type = string
}

variable "account_id" {
  description = "AWS Account ID"
  type = string
}

variable "cluster_name" {
  description = "The name of the ECS Cluster"
  type        = string
}

variable "cluster_arn" {
  description = "The ARN of the ECS Cluster"
  type        = string
}

variable "service_name" {
  description = "The name of the ECS service being created."
  type        = string
}

variable "use_fargate" {
  description = "Flag to decide if ECS cluster is based on Fargate or Autoscaling based EC2"
  type        = bool
}

variable "launch_type" {
  description = "(Optional) Launch type on which to run your service."
  type        = string
}

variable "service_task_network_mode" {
  description = "Docker networking mode to use for the containers in the task."
  type        = string
}

variable "service_task_pid_mode" {
  description = "Process namespace to use for the containers in the task."
  type        = string
}

variable "service_volumes" {
  description = "A list of volumes that containers in the service may use."
  type        = list(map(string))
}

variable "service_min_capacity" {
  description = "Min capacity of the scalable target."
  type        = number
}

variable "service_max_capacity" {
  description = "Max capacity of the scalable target"
  type        = number
}

variable "service_desired_capacity" {
  description = "Number of instances of the task definition to place and keep running"
  type        = number
}

variable "container_configurations" {
    description = "The Configurations used by Container"
}

variable "ecs_task_execution_role_arn" {
    description = "ECS Task Execution Role ARN"
    type        = string
}

variable "ecs_task_role_arn" {
    description = "ECS Task Role ARN"
    type        = string
}

variable "create_service_log_group" {
  description = "(Optional, default true) Create a cloudwatch log group to send the service logs"
  type        = bool
}

variable "log_group_retention" {
  description = "(Optional, default 0) The Log Retention period in days"
  type        = number
}

## Tags
variable "default_tags" {
  description = "A map of tags to assign to all the resource."
  type        = map(any)
}