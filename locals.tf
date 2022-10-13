locals {
    ecs_cluster_arn = var.create_ecs_cluster ? module.ecs_cluster[0].cluster_arn : data.aws_ecs_cluster.this[0].arn

    autoscaling_capacity_providers = {for capacity_provider in var.autoscaling_capacity_providers: 
                                        capacity_provider.name => merge(
                                                                    capacity_provider, 
                                                                    { asg_arn = module.asg[capacity_provider.asg_name].arn })}

    ecs_instance_policy_names = [for policy in var.ecs_instance_policies: policy.name]
    ecs_task_policy_names = [for policy in var.ecs_task_policies: policy.name]
    ecs_task_execution_policy_names = [for policy in var.ecs_task_execution_policies: policy.name]

    ecs_instance_roles = [
                            {
                                name = "ecs-instance"
                                description = "IAM Role for ECS Container Agent running on EC2 instances with trusted Entity - EC2 Service"
                                service_names = [
                                    "ec2.amazonaws.com"
                                ]  
                                policy_map = {
                                    policy_arns = local.ecs_instance_policy_names
                                }                   
                            }
    ]

    ecs_task_roles = [                
                        {
                            name = "ecs-task"
                            description = "IAM Role for ECS Task with trusted Entity - ECS Task Service"
                            service_names = [
                                "ecs-tasks.amazonaws.com"
                            ]
                            policy_map = {
                                policy_arns = local.ecs_task_policy_names
                            }                  
                        },
                        {
                            name = "ecs-task-execution"
                            description = "IAM Role for ECS Task Exeution with trusted Entity - ECS Task Service"
                            service_names = [
                                "ecs-tasks.amazonaws.com"
                            ]  
                            policy_map = {
                                policy_arns = local.ecs_task_execution_policy_names
                            }                   
                        }
                    ]

}