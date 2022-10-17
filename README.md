# ARJ-Stack: AWS ECS Terraform module

A Terraform module for configuring ECS Cluster and ECS Services

## Resources
This module features the following components to be provisioned with different combinations:
- ECS Cluster [[aws_ecs_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster)]
- ECS Cluster Capacity Providers [[aws_ecs_cluster_capacity_providers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers)]
- ECS Capacity Provider [[aws_ecs_capacity_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_capacity_provider)]
- Service Discovery Private DNS Namespace [[aws_service_discovery_private_dns_namespace](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_private_dns_namespace)]
- Service Discovery Service [[aws_service_discovery_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_service)]
- ECS Task Definition [[aws_ecs_task_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition)]
- ECS Service [[aws_ecs_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service)]
- Clouswatch Log Group [[aws_cloudwatch_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group)]
- Application Autoscaling Target [[aws_appautoscaling_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target)]
    - ECS service Autoscaling
- Application AutoScaling Policy [[aws_appautoscaling_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy)]
    - Scale-up Policy with scalable dimension - `ecs:service:DesiredCount`
    - Scale-down policy with scalable dimension - `ecs:service:DesiredCount`
- Cloudwatch metric Alarm [[aws_cloudwatch_metric_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm)]
    - CloudWatch alarm (with metric `CPUUtilization`) that triggers the autoscaling up policy
    - CloudWatch alarm (with metric `CPUUtilization`) that triggers the autoscaling down policy
- Security Group [[ecs_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)]
    - Security Group to be attached with ECS Service/Task
- Security Group Rules [[aws_security_group_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)]
- IAM Policy [[aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizationiam_policy)]
    - Policies to define permissions used by ECS Container Agent and ECS Container Tasks
- IAM Roles [[aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)]
    - IAM Role that the Amazon ECS container agent and the Docker daemon can assume
    - IAM Role that Amazon ECS container task to make calls to other AWS services
- IAM Roles-Policy Attachments [[aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)]


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.22.0 |

## Examples

Refer [Configuration Examples](https://github.com/arjstack/terraform-aws-examples/tree/main/aws-ecs) for effectively utilizing this module.

## Inputs

#### ECS Cluster Specific Properties
---

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="create_ecs_cluster"></a> [create_ecs_cluster](#input\_create\_ecs\_cluster) | Flag to decide if a new ECS cluster should be created | `bool` | `true` | no |  |
| <a name="cluster_name"></a> [cluster_name](#input\_cluster\_name) | The name of the ECS Cluster | `string` |  | yes |  |
| <a name="use_fargate"></a> [use_fargate](#input\_use\_fargate) | Flag to decide if ECS cluster is based on Fargate or Autoscaling based EC2 | `bool` | `true` | no |  |
| <a name="enable_cloudwatch_container_insights"></a> [enable_cloudwatch_container_insights](#input\_enable\_cloudwatch\_container\_insights) | Flag to decide if container insights should be enabled | `bool` | `true` | no |  |
| <a name="enable_execute_command_configuration"></a> [enable_execute_command_configuration](#input\_enable\_execute\_command\_configuration) | Flag to decide if Execute Command Configuration should be set for cluster | `bool` | `false` | no |  |
| <a name="execute_command_configurations"></a> [execute_command_configurations](#execute\_command\_configurations) | The details of the execute command configuration | `map` | `{}` | no |  |
| <a name="fargate_capacity_providers"></a> [fargate_capacity_providers](#input\_fargate\_capacity\_providers) | Map of Fargate Capacity Providers's Configurations to be used by ECS cluster with default strategy as mentioned in the example | `map` | `{}` | no | <pre>{<br>   "FARGATE" = {<br>     default_strategy = {<br>       base = 1<br>       weight = 100<br>     }<br>   }<br>   "FAGATE_SPOT" = {<br>     default_strategy = {<br>       base = 1<br>       weight = 1<br>     }<br>   }<br>}<br><pre> |
| <a name="autoscaling_capacity_providers"></a> [autoscaling_capacity_providers](#autoscaling\_capacity\_providers) | List of Autoscaling Capacity Providers' Configurations to be used by ECS cluster where each entry will be a map | `list` | `[]` | no | <pre>[<br>   {<br>     name = "PRIMARY"<br>     asg_arn = "arn:aws:asg::123456789012:asg/prod"<br>     managed_termination_protection = "ENABLED"<br>     configure_managed_scaling = true<br>     ms_instance_warmup_period = 300<br>     ms_minimum_scaling_step_size = 1<br>     ms_maximum_scaling_step_size = 2<br>     ms_target_capacity = 1<br>     ms_status = "ENABLED"<br><br>     default_strategy = {<br>       base = 1<br>       weight = 100<br>   }<br>] |
| <a name="create_dns_namespace"></a> [create_dns_namespace](#input\_create\_dns\_namespace) | Decide if private DNS namespace is required for Service Discovery | `bool` | `false` | no |  |
| <a name="dns_name"></a> [dns_name](#input\_dns\_name) | The name of the namespace.<br>Used only if `create_dns_namespace` is set true | `string` | `<cluster_name>.ecs.local` | no |  |
| <a name="vpc_id"></a> [vpc_id](#input\_vpc\_id) | The ID of VPC that is used to associate the namespace with | `string` |  | no |  |
| <a name="create_service"></a> [create_service](#input\_create\_service) | Flag to decide if ECS service should also be created | `bool` | `false` | no |  |

#### ECS Service
---

- All the below Properties will be ignored if `create_service` is not set `true`

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="aws_region"></a> [aws_region](#input\_aws\_region) | AWS region where ECS service is provisioned | `string` |  | yes |  |
| <a name="service_name"></a> [service_name](#input\_service\_name) | The name of the ECS service being created. | `string` |  | yes |  |
| <a name="service_scalability"></a> [service_scalability](#service\_scalability) | The scalability matrix configuration map for ECS servcie | `map(number)` | <pre>{<br>   min_capacity = 1<br>   max_capacity = 1<br>   desired_capacity = 1<br>}<pre> | no |  |
| <a name="service_launch_type"></a> [service_launch_type](#input\_service\_launch\_type) | Launch type on which to run your service.<br>`FARGATE` will automatically be set if `use_fargate` is set true  | `string` | `EC2` | no |  |
| <a name="service_task_network_mode"></a> [service_task_network_mode](#input\_service\_task\_network\_mode) | The network mode used by the containers in the ECS Service Task. | `string` | `awsvpc` | no |  |
| <a name="service_task_pid_mode"></a> [service_task_pid_mode](#input\_service\_task_pid\_mode) | Process namespace to use for the containers in the task. | `string` |  | no |  |
| <a name="service_volumes"></a> [service_volumes](#service\_volumes) | A list of volumes that containers in the service may use | `list(map(string))` | `[]` | no |  |
| <a name="container_configurations"></a> [container_configurations](#container\_configurations) | The Configurations used by Container | `map` |  | yes |  |
| <a name="policies"></a> [policies](#policy) | List of Policies to be provisioned | `[]` |  | no |  |
| <a name="ecs_task_policies"></a> [ecs_task_policies](#ecs\_policy) | List of Policies to be attached with ECS Task container  | `string` |  | no |  |
| <a name="ecs_task_execution_policies"></a> [ecs_task_execution_policies](#ecs\_policy) | List of Policies to be attached with ECS Task Execution | `string` |  | no |  |
| <a name="enable_service_discovery"></a> [enable_service_discovery](#input\_enable\_service\_discovery) | Flag to decide if service needs to be registered with service discovery namespace | `bool` | `false` | no |  |

#### ECS Service - Network Configuration
---

- All the below Properties will be ignored if `create_service` is not set `true`

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="service_subnets"></a> [service_subnets](#input\_service\_subnets) | List of subnet IDs associated with the task or service. | `list(string)` |  | yes | <pre>[ "subnet-xxxxx......", "subnet-xxxx4747cv..." ] |
| <a name="assign_public_ip"></a> [assign_public_ip](#input\_assign\_public\_ip) | Assign a public IP address to the ENI (Fargate launch type only) | `bool` | `false` | no |  |
| <a name="create_service_sg"></a> [create_service_sg](#input\_create\_service\_sg) | Flag to decide to create Security Group for ECS service/task | `bool` | `false` | no |  |
| <a name="service_sg_name"></a> [service_sg_name](#input\_service\_sg\_name) | The name of the Security group | `string` |  | no | Required when `create_service_sg` is set true |
| <a name="service_sg_rules"></a> [service_sg_rules](#input\_sg\_rules) | Map of Security Group Rules mapped with 2 Keys `ingress` and `egress`. <br>The value for each key will be a list of Security group rules where each entry of the list will again be a map of Rule configuration | `map` | `{}` | no | <pre>{<br>   ingress = [<br>      {<br>        rule_name = "Self Ingress Rule"<br>        description = "Self Ingress Rule"<br>        from_port =0<br>        to_port = 0<br>        protocol = "-1"<br>        self = true<br>      },<br>      {<br>        rule_name = "Ingress from IPv4 CIDR"<br>        description = "IPv4 Rule"<br>        from_port = 443<br>        to_port = 443<br>        protocol = "tcp"<br>        cidr_blocks = ["xx.xx.xx.xx/xx", "yy.yy.yy.yy/yy"]<br>      }<br>   ]<br>   egress =[<br>      {<br>        rule_name = "Self Egress Rule"<br>        description = "Self Egress Rule"<br>        from_port =0<br>        to_port = 0<br>        protocol = "-1"<br>        self = true<br>      }<br>   ]<br>} |
| <a name="service_additional_sg"></a> [service_additional_sg](#input\_service\_additional\_sg) | List of Existing Security Group IDs associated with the task or service | `list(string)` | `[]` | no | <pre>[ "sg-xxxxx......", "sg-xxxx4747cv..." ] |

#### ECS Service - Load Balancer Configuration
---

- All the below Properties will be ignored if `create_service` is not set `true`

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="attach_load_balancer"></a> [attach_load_balancer](#input\_attach\_load\_balancer) | Flat to decide if ECS service should be attached to load balancer | `bool` | `true` | no |  |
| <a name="load_balancer_arn"></a> [load_balancer_arn](#input\_load\_balancer\_arn) | ARN of the load balancer | `string` |  | no | Requried when `attach_load_balancer` is set true |

#### ECS Service - Log Management
---

- All the below Properties will be ignored if `create_service` is not set `true`

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="create_service_log_group"></a> [create_service_log_group](#input\_create\_service\_log\_group) | Flag to decide if Cloudwatch log group should be ctreated for sending the service logs to | `bool` | `true` | no |  |
| <a name="log_group_retention"></a> [log_group_retention](#input\_log\_group\_retention) | The Log Retention period in days | `number` | `0` | no |  |

#### Tags
---

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="default_tags"></a> [default_tags](#input\_default\_tags) | A map of tags to assign to all the resource. | `map` | `{}` | no |  |

## Nested Configuration Maps:  

#### execute_command_configurations

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="kms_key_id"></a> [kms_key_id](#input\_kms\_key\_id) | The AWS Key Management Service key ID to encrypt the data between the local client and the container. | `string` | `null` | no |  |
| <a name="logging"></a> [logging](#input\_logging) | The log setting to use for redirecting logs for your execute command results.<br>Valid values are NONE, DEFAULT and OVERRIDE | `string` | `"DEFAULT"` | no |  |
| <a name="log_configuration"></a> [log_configuration](#log\_configuration) | The log configuration (5 points below) for the results of the execute command actions Required when logging is OVERRIDE. | `map` |  | no |  |

#### log_configuration

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="cloudwatch_encryption_enabled"></a> [cloudwatch_encryption_enabled](#input\_cloudwatch\_encryption\_enabled) | Whether or not to enable encryption on the CloudWatch logs. If not specified, encryption will be disabled. | `string` | `null` | no |  |
| <a name="cloudwatch_log_group_name"></a> [cloudwatch_log_group_name](#input\_cloudwatch\_log\_group\_name) | The name of the CloudWatch log group to send logs to. | `string` |  | no |  |
| <a name="s3_bucket_name"></a> [s3_bucket_name](#input\_s3\_bucket\_name) | The name of the S3 bucket to send logs to. | `string` |  | no |  |
| <a name="s3_bucket_encryption_enabled"></a> [s3_bucket_encryption_enabled](#input\_s3\_bucket\_encryption\_enabled) | Whether or not to enable encryption on the logs sent to S3. If not specified, encryption will be disabled. | `bool` |  | no |  |
| <a name="s3_key_prefix"></a> [s3_key_prefix](#input\_s3\_key\_prefix) | An optional folder in the S3 bucket to place logs in. | `string` |  | no |  |

#### autoscaling_capacity_providers

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="name"></a> [name](#input\_name) | Name of the capacity provider. | `string` |  | yes |  |
| <a name="asg_arn"></a> [asg_arn](#input\_asg_arn) | ASG ARN to be used | `string` |  | yes |  |
| <a name="managed_termination_protection"></a> [managed_termination_protection](#input\_managed_termination_protection) | Enables or disables container-aware termination of instances in the auto scaling group when scale-in happens.<br>Valid values are `ENABLED` and `DISABLED`. | `string` |  | no |  |
| <a name="ms_instance_warmup_period"></a> [ms_instance_warmup_period](#input\_ms_instance_warmup_period) | Period of time, in seconds, after a newly launched Amazon EC2 instance can contribute to CloudWatch metrics for Auto Scaling group. | `number` | `300` | no |  |
| <a name="ms_minimum_scaling_step_size"></a> [ms_minimum_scaling_step_size](#input\_ms_minimum_scaling_step_size) | Minimum step adjustment size. A number between 1 and 10,000. | `number` |  | no |  |
| <a name="ms_maximum_scaling_step_size"></a> [ms_maximum_scaling_step_size](#input\_ms_maximum_scaling_step_size) | Maximum step adjustment size. A number between 1 and 10,000. | `number` |  | no |  |
| <a name="ms_target_capacity"></a> [ms_target_capacity](#input\_ms_target_capacity) | Target utilization for the capacity provider. A number between 1 and 100. | `number` |  | no |  |
| <a name="ms_status"></a> [ms_status](#input\_ms_status) | Whether auto scaling is managed by ECS. | `string` |  | no |  |
| <a name="default_strategy"></a> [default_strategy](#input\_default_strategy) | Default strategy for provider (It should be a map of values with the keys `base` and `weight` ) | `map` | `{}` | no |  |
| <a name="tags"></a> [tags](#input\_tags) | A map of tags to assign to Capacity Provider | `map` | `{}` | no |  |

#### service_scalability

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="min_capacity"></a> [min_capacity](#input\_min\_capacity) | Min capacity of the scalable target. | `number` | `1` | no |  |
| <a name="max_capacity"></a> [max_capacity](#input\_max\_capacity) | Max capacity of the scalable target. | `number` | Value of `min_capacity` | no |  |
| <a name="desired_capacity"></a> [desired_capacity](#input\_desired\_capacity) | Number of instances of the task definition to place and keep running. | `number` | Value of `min_capacity` | no |  |

#### service_volumes

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="name"></a> [name](#input\_name) | Name of the volume. | `string` |  | yes |  |
| <a name="host_path"></a> [host_path](#host\_path) | Path on the host container instance that is presented to the container. | `string` |  | no |  |

#### container_configurations
| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="name"></a> [name](#input\_name) | The name of the container | `string` |  | yes |  |
| <a name="image"></a> [image](#input\_image) | Docker Image to be deployed in the container | `string` |  | yes |  |
| <a name="container_port"></a> [container_port](#input\_container_port) | Container Port | `number` |  | yes |  |
| <a name="host_port"></a> [host_port](#input\_host_port) | Host Port | `number` |  | yes |  |
| <a name="cpu"></a> [cpu](#input\_cpu) | CPU assigned to container | `string` | `1024` | no |  |
| <a name="memory"></a> [memory](#input\_memory) | Memory assigned to container | `string` | `1024` | no |  |
| <a name="log_group"></a> [log_group](#input\_log_group) | Cloudwatch log group for the logs to be sent to | `string` |  | no |  |

#### policy

Policy content to be add to the new policy will be read from the JSON document.<br>
&nbsp;&nbsp;&nbsp;- JSON document must be placed in the directory `policies` under root directory.<br>
&nbsp;&nbsp;&nbsp;- The naming format of the file: <Value set in `name` property>.json

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="name"></a> [name](#input\_name) | The name of the policy. | `string` | `yes` | yes |  |
| <a name="description"></a> [description](#input\_description) | Description of the IAM policy. | `string` | `<name of the policy>` | no |  |
| <a name="path"></a> [path](#input\_path) | Path in which to create the policy. | `string` | `"/"` | no |  |
| <a name="tags"></a> [tags](#input\_tags) | A map of tags to assign to the policy. | `map` | `{}` | no |  |

#### ecs_policy
| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="name"></a> [name](#input\_name) | Policy Name | `string` |  | yes |  |
| <a name="arn"></a> [arn](#input\_arn) | Policy ARN (if existing policy) | `string` |  | no |  |

#### sg_rules [ Ingress / Egress ]

- `cidr_blocks` Cannot be specified with `source_security_group_id` or `self`.
- `ipv6_cidr_blocks` Cannot be specified with `source_security_group_id` or `self`.
- `source_security_group_id` Cannot be specified with `cidr_blocks`, `ipv6_cidr_blocks` or `self`.
- `self` Cannot be specified with `cidr_blocks`, `ipv6_cidr_blocks` or `source_security_group_id`.

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="rule_name"></a> [rule_name](#input\_rule\_name) | The name of the Rule (Used for terraform perspective to maintain unicity) | `string` |  | yes | |
| <a name="description"></a> [description](#input\_description) | Description of the rule. | `string` |  | yes | |
| <a name="from_port"></a> [from_port](#input\_from\_port) | Start port (or ICMP type number if protocol is "icmp" or "icmpv6"). | `number` |  | yes | |
| <a name="to_port"></a> [to_port](#input\_to\_port) | End port (or ICMP code if protocol is "icmp"). | `number` |  | yes | |
| <a name="protocol"></a> [protocol](#input\_protocol) | Protocol. If not icmp, icmpv6, tcp, udp, or all use the protocol number | `string | number` |  | yes | |
| <a name="self"></a> [self](#input\_self) | Whether the security group itself will be added as a source to this ingress rule.  | `bool` |  | no | |
| <a name="cidr_blocks"></a> [cidr_blocks](#input\_cidr\_blocks) | List of IPv4 CIDR blocks | `list(string)` |  | no | |
| <a name="ipv6_cidr_blocks"></a> [ipv6_cidr_blocks](#input\_ipv6\_cidr\_blocks) | List of IPv6 CIDR blocks. | `list(string)` |  | no | |
| <a name="source_security_group_id"></a> [source_security_group_id](#input\_source\_security\_group\_id) | Security group id to allow access to/from | `string` |  | no | |

## Outputs

| Name | Type | Description |
|:------|:------|:------|
| <a name="cluster_arn"></a> [cluster_arn](#output\_cluster\_arn) | The ID/ARN of the ECS cluster | `string` | 
| <a name="service_discovery_namespace_id"></a> [service_discovery_namespace_id](#output\_service\_discovery\_namespace\_id) | ID of Service Discovery Private Namespace | `string` | 
| <a name="service_discovery_namespace_arn"></a> [service_discovery_namespace_arn](#output\_service\_discovery\_namespace\_arn) | ARN of Service Discovery Private Namespace | `string` | 
| <a name="service_arn"></a> [service_arn](#output\_service\_arn) | ARN of ECS Service | `string` | 
| <a name="task_definition_arn"></a> [task_definition_arn](#output\_task\_definition\_arn) | Full ARN of the Task Definition | `string` | 
| <a name="ecs_task_role"></a> [ecs_task_role](#output\_ecs\_task\_role) | IAM Role for ECS Task with trusted Entity - ECS Task Service | `string` | 
| <a name="ecs_task_execution_role"></a> [ecs_task_execution_role](#output\_ecs\_task\_execution\_role) | IAM Role for ECS Task Exeution with trusted Entity - ECS Task Service | `string` | 
| <a name="service_log_group_name"></a> [service_log_group_name](#output\_service\_log\_group\_name) | Name of the Cloudwatch log Group for ECS Service | `string` | 
| <a name="service_log_group_arn"></a> [service_log_group_arn](#output\_service\_log\_group\_arn) | ARN of the Cloudwatch log Group for ECS Service | `string` | 
| <a name="service_discovery_id"></a> [service_discovery_id](#output\_service\_discovery\_id) | ID of Service Discovery | `string` | 
| <a name="service_discovery_arn"></a> [service_discovery_arn](#output\_service\_discovery\_arn) | ARN of Service Discovery | `string` | 

## Authors

Module is maintained by [Ankit Jain](https://github.com/ankit-jn) with help from [these professional](https://github.com/arjstack/terraform-aws-iam/graphs/contributors).

