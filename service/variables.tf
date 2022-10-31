##################################################
## ECS Service, Task, Permissions Management
##################################################
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

variable "service_task_cpu" {
  description = "Number of cpu units used by the task."
  type        = number
}

variable "service_task_memory" {
  description = "Amount (in MiB) of memory used by the task."
  type        = number
}

variable "service_volumes" {
  description = "A list of volumes that containers in the service may use."
  type        = list(map(string))
}

variable "min_capacity" {
  description = "Min capacity of the scalable target."
  type        = number
}

variable "max_capacity" {
  description = "Max capacity of the scalable target"
  type        = number
}

variable "desired_capacity" {
  description = "Number of instances of the task definition to place and keep running"
  type        = number
}

variable "container_configurations" {
    description = "The Configurations used by Container"
}

variable "container_definition" {
    description = "The container definition used by Container"
    type = string
}

variable "ecs_task_execution_role_arn" {
    description = "ECS Task Execution Role ARN"
    type        = string
}

variable "ecs_task_role_arn" {
    description = "ECS Task Role ARN"
    type        = string
}

##################################################
## Network configurations for ECS Service/Task
##################################################
variable "subnets" {
    description = "List of subnet IDs associated with the task or service."
    type        = list(string)
}

variable "security_groups" {
    description = "(Optional) List of Security Group IDs associated with the task or service."
    type        = list(string)
}

variable "assign_public_ip" {
    description = "(Optional, Required only for FARGATE) Assign a public IP address to the ENI (Fargate launch type only)."
    type        = bool
}

##################################################
## Load Balancer Configurations
##################################################
variable "attach_load_balancer" {
    description = "(Optional) Decision if ECS service should be attached to load balancer"
    type        = bool
}

variable "load_balancer_configs" {
    description = "(Optional) Target Group confgiurations for Service load balancing"
}

##################################################
## Log management for ECS Service
##################################################
variable "create_log_group" {
  description = "(Optional, default true) Create a cloudwatch log group to send the service logs"
  type        = bool
}

variable "log_group_retention" {
  description = "(Optional, default 0) The Log Retention period in days"
  type        = number
}

##################################################
## Service Discovery Service Configurations
##################################################
variable "enable_service_discovery" {
  description = "Decide if service should discovery should be enabled"
  type        = bool
}

variable "namespace_id" {
  description = "The ID of the namespace to use for DNS configuration."
  type        = string
}

variable "routing_policy" {
  description = <<EOF
(Optional) The routing policy that you want to apply to all records that Route 53 creates 
when register an instance and specify the service. Valid Values: MULTIVALUE, WEIGHTED
EOF
  type        = string
}

##################################################
## Tags
##################################################
variable "default_tags" {
  description = "A map of tags to assign to all the resource."
  type        = map(any)
}