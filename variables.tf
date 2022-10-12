variable "create_ecs_cluster" {
  description = "(Optional, default true) Flag to decide if a new ECS cluster should be created"
  type        = bool
  default     = true
}

variable "ecs_cluster_name" {
  description = "(Required) The name of the ECS Cluster"
  type        = string
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

## Tags
variable "default_tags" {
  description = "(Optional) A map of tags to assign to all the resource."
  type        = map(any)
  default     = {}
}