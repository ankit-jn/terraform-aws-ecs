variable "cluster_name" {
  description = "The name of the ECS Cluster"
  type        = string
}

variable "use_fargate" {
  description = "Flag to decide if ECS cluster is based on Fargate or Autoscaling based EC2"
  type        = bool
}

variable "enable_cloudwatch_container_insights" {
  description = "Flag to decide if container insights should be enabled"
  type        = bool
}

variable "enable_execute_command_configuration" {
  description = "Flag to decide if Execute Command Configuration should be set for cluster"
  type        = bool
}

variable "execute_command_configurations" {
  description = "The details of the execute command configuration"
}

variable "fargate_capacity_providers" {
  description = "The Configuration Map of Fargate based capacity Providers"
}

variable "autoscaling_capacity_providers" {
  description = "The Configuration Map of Autoscaling based capacity Providers"
}

## Tags
variable "default_tags" {
  description = "A map of tags to assign to all the resource."
  type        = map(any)
}