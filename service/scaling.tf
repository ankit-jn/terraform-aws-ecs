locals {
    ecs_autoscale_role = "arn:aws:iam::${var.account_id}:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService"
}

resource aws_appautoscaling_target "this" {
  service_namespace  = "ecs"
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = local.ecs_autoscale_role
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
}

# Automatically scale capacity up by one
resource aws_appautoscaling_policy "asg_policy_up" {
  name               = "${aws_ecs_service.this.name}-asg-up"
  service_namespace  = aws_appautoscaling_target.this.service_namespace
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [aws_appautoscaling_target.this]
}

# Automatically scale capacity down by one
resource aws_appautoscaling_policy "asg_policy_down" {
  name               = "${aws_ecs_service.this.name}-down"
  service_namespace  = aws_appautoscaling_target.this.service_namespace
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [aws_appautoscaling_target.this]
}

# CloudWatch alarm that triggers the autoscaling up policy
resource aws_cloudwatch_metric_alarm "cw_metric_cpu_high" {
  alarm_name          = "${aws_ecs_service.this.name}-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "85"

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = aws_ecs_service.this.name
  }

  alarm_actions = [aws_appautoscaling_policy.asg_policy_up.arn]
}

# CloudWatch alarm that triggers the autoscaling down policy
resource aws_cloudwatch_metric_alarm "cw_metric_cpu_low" {
  alarm_name          = "${aws_ecs_service.this.name}-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = aws_ecs_service.this.name
  }

  alarm_actions = [aws_appautoscaling_policy.asg_policy_down.arn]
}

