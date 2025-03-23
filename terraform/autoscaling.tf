resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity        = 4
  min_capacity        = 1
  resource_id         = "service/${aws_ecs_cluster.my_cluster.name}/${aws_ecs_service.frontend.name}"
  scalable_dimension  = "ecs:service:DesiredCount"
  service_namespace   = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_scale_out" {
  name                = "ecs-scale-out"
  policy_type         = "TargetTrackingScaling"
  resource_id         = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension  = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace   = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 75.0    
    scale_out_cooldown = 60
    scale_in_cooldown  = 120

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

resource "aws_appautoscaling_policy" "ecs_scale_in" {
  name                = "ecs-scale-in"
  policy_type         = "TargetTrackingScaling"
  resource_id         = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension  = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace   = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 30.0
    scale_out_cooldown = 60
    scale_in_cooldown  = 120

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
  }
}
