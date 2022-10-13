variable "create_ecs_cluster" {
  description = "(Optional, default true) Flag to decide if a new ECS cluster should be created"
  type        = bool
  default     = true
}

variable "ecs_cluster_name" {
  description = "(Required) The name of the ECS Cluster"
  type        = string
}

variable "use_fargate" {
  description = "Flag to decide if ECS cluster is based on Fargate or Autoscaling based EC2"
  type = bool
  default = true
}

variable "enable_cloudwatch_container_insights" {
  description = "(Optional, default false) Flag to decide if container insights should be enabled"
  type        = bool
  default     = true
}

variable "enable_execute_command_configuration" {
  description = "(Optional, default false) Flag to decide if Execute Command Configuration should be set for cluster"
  type        = bool
  default     = false
}

variable "execute_command_configurations" {
  description = <<EOF
The details of the execute command configuration with the following Key-value pairs

1. kms_key_id - (Optional) The AWS Key Management Service key ID to encrypt the data between the local client and the container.
2. logging - (Optional) The log setting to use for redirecting logs for your execute command results. 
                     Valid values are NONE, DEFAULT and OVERRIDE
3. log_configuration - (Optional) The log configuration (5 points below) for the results of the execute command actions Required when logging is OVERRIDE

3.1. cloud_watch_encryption_enabled - (Optional) Whether or not to enable encryption on the CloudWatch logs. If not specified, encryption will be disabled.
3.2. cloud_watch_log_group_name - (Optional) The name of the CloudWatch log group to send logs to.
3.3. s3_bucket_name - (Optional) The name of the S3 bucket to send logs to.
3.4. s3_bucket_encryption_enabled - (Optional) Whether or not to enable encryption on the logs sent to S3. If not specified, encryption will be disabled.
3.5. s3_key_prefix - (Optional) An optional folder in the S3 bucket to place logs in.
EOF
  default     = {}
}

variable "fargate_capacity_providers" {
  description = <<EOF
Providers Map where,
Map Key: Provider Type; Aloowed Values: FARGATE, FARGATE_SPOT
Map Value: configuration of providers
EOF
  default = {}
}

## Map Key of `autoscaling_capacity_providers` and `auto_scaling_groups` should be the same
## 
variable "autoscaling_capacity_providers" {
  description = <<EOF
Providers Map where,
Map Key: Name of the capacity provider.
Map Value: Configuration map of the provider
  name: (Required) Name of the capacity provider.
  instance_type: (Optional, default t3.micro) The Instance type used in Autoscaling configurations
  managed_termination_protection:  (Optional) - Enables or disables container-aware termination of instances 
                                  in the auto scaling group when scale-in happens. 
                                  Valid values are ENABLED and DISABLED
  ms_instance_warmup_period: (Optional, defaulu 300) Period of time, in seconds, after a newly launched Amazon 
                            EC2 instance can contribute to CloudWatch metrics for Auto Scaling group.
  ms_minimum_scaling_step_size: (Optional) Maximum step adjustment size. A number between 1 and 10,000.
  ms_maximum_scaling_step_size: (Optional) Minimum step adjustment size. A number between 1 and 10,000.
  ms_target_capacity: (Optional) Target utilization for the capacity provider. A number between 1 and 100.
  ms_status: (Optional) Whether auto scaling is managed by ECS.
  default_strategy: Default strategy for provider (Map having value for base and weight )
  tags: (Optional) A map of tags to assign to Capacity Provider
EOF
  default = {}
}

## Map Key of `autoscaling_capacity_providers` and `auto_scaling_groups` should be the same
variable "auto_scaling_groups" {
  description = "Auto Scaling Groups used with Autoscaling Capacity Providers"
  default = {}
}
## Tags
variable "default_tags" {
  description = "(Optional) A map of tags to assign to all the resource."
  type        = map(any)
  default     = {}
}