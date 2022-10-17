variable "aws_region" {
  description = "THe region to use"
  type = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string 
  default     = ""
}

variable "create_ecs_cluster" {
  description = "(Optional, default true) Flag to decide if a new ECS cluster should be created"
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "(Required) The name of the ECS Cluster"
  type        = string
}

variable "create_dns_namespace" {
  description = "Decide if private DNS namespace is required for Service Discovery"
  type = bool
  default = false
}

variable "dns_name" {
  description = "(Optional, default `<cluster-name>.ecs.local`) The name of the namespace."
  type        = string
  default     = null
}

variable "enable_service_discovery" {
  description = "Decide if service needs to be registered with service discovery namespace"
  type        = bool
  default     = false
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

variable "autoscaling_capacity_providers" {
  description = <<EOF
Providers Map where,
Map Key: Name of the capacity provider.
Map Value: Configuration map of the provider
  name: (Required) Name of the capacity provider.
  asg_arn: ASG ARN to be used
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
  default = []
}

variable "policies" {
  description = <<EOF
List Policies to be provisioned where each entry will be a map for Policy configuration
Refer https://github.com/arjstack/terraform-aws-iam#policy for the structure
EOF
  default = []
}

variable "ecs_task_policies" {
  description = <<EOF
policy_list - List of Policies to be attached with ECS Task container where each entry will be map with following entries
    name - Policy Name
    arn - Policy ARN (if existing policy)
EOF
  default = []
}

variable "ecs_task_execution_policies" {
  description = <<EOF
policy_list - List of Policies to be attached with ECS Task Execution where each entry will be map with following entries
    name - Policy Name
    arn - Policy ARN (if existing policy)
EOF
  default = []
}

variable "service_name" {
  description = "The name of the ECS service being created."
  type        = string
}

variable "service_scalability" {
  description = <<EOF
The scalability matrix map
min_capacity: (Required) Min capacity of the scalable target.
max_capacity: (Required) Max capacity of the scalable target.
desired_capacity: (Optional) Number of instances of the task definition to place and keep running.
EOF
  type        = map(number)
}

variable "service_launch_type" {
  description = "(Optional) Launch type on which to run your service."
  type        = string
  default     = "EC2" # FARGATE will automatically be set if `use_fargate` is set true 
}

variable "service_task_network_mode" {
  description = "The network mode used by the containers in the ECS Service Task."
  default     = "awsvpc"
  type        = string
}

variable "service_task_pid_mode" {
  description = "Process namespace to use for the containers in the task."
  default     = null
  type        = string
}

variable "service_volumes" {
  description = "A list of volumes that containers in the service may use."
  type        = list(map(string))
  default     = []
}

variable "container_configurations" {
    description = <<EOF
The Configurations used by Container

name: (Required) The name of the container
image: (Required) Docker Image to be deployed in the container
container_port: (Required) Container Port
host_port: (Required) Host Port

cpu: (Optional, default 1024) CPU assigned to contained
memory: (Optional, default 1024) Memory assigned to container

log_group: (Optional, default null) The CLoudwath log group for the logs to be sent to

command: (Optional, default null) Commands to run in thew container
mountPoints: (Optional, default null) Mount points to be setup in the container
environment: (Optional, default null) Array of Environment variables 
EOF

}

variable "service_subnets" {
    description = "List of subnet IDs associated with the task or service."
    type        = list(string)
}

variable "assign_public_ip" {
    description = "(Optional, Required only for FARGATE) Assign a public IP address to the ENI (Fargate launch type only)."
    type        = bool
    default     = false
}

variable "create_service_sg" {
    description = "Decide to create Security Group for ECS service/task"
}

variable "service_sg_name" {
    description = "The name of the Security group"
}

variable "service_sg_rules" {
    description = <<EOF

(Optional) Configuration List for Security Group Rules of Security Group:
It is a map of Rule Pairs where,
Key of the map is Rule Type and Value of the map would be an array of Security Rules Map 
There could be 2 Rule Types [Keys] : 'ingress', 'egress'

(Optional) Configuration List of Map for Security Group Rules where each entry will have following properties:

rule_name: (Required) The name of the Rule (Used for terraform perspective to maintain unicity)
description: (Optional) Description of the rule.
from_port: (Required) Start port (or ICMP type number if protocol is "icmp" or "icmpv6").
to_port: (Required) End port (or ICMP code if protocol is "icmp").
protocol: (Required) Protocol. If not icmp, icmpv6, tcp, udp, or all use the protocol number

self: (Optional) Whether the security group itself will be added as a source to this ingress rule. 
cidr_blocks: (Optional) List of IPv4 CIDR blocks
ipv6_cidr_blocks: (Optional) List of IPv6 CIDR blocks.
source_security_group_id: (Optional) Security group id to allow access to/from
 
Note: 
1. `cidr_blocks` Cannot be specified with `source_security_group_id` or `self`.
2. `ipv6_cidr_blocks` Cannot be specified with `source_security_group_id` or `self`.
3. `source_security_group_id` Cannot be specified with `cidr_blocks`, `ipv6_cidr_blocks` or `self`.
4. `self` Cannot be specified with `cidr_blocks`, `ipv6_cidr_blocks` or `source_security_group_id`.

EOF
    default = []
}

variable "service_additional_sg" {
    description = "(Optional) List of Existing Security Group IDs associated with the task or service."
    type        = list(string)
    default = []
}

variable "create_service_log_group" {
  description = "(Optional, default true) Create a cloudwatch log group to send the service logs"
  type        = bool
  default     = true
}

variable "log_group_retention" {
  description = "(Optional, default 0) The Log Retention period in days"
  type        = number
  default     = 0
}
## Tags
variable "default_tags" {
  description = "(Optional) A map of tags to assign to all the resource."
  type        = map(any)
  default     = {}
}