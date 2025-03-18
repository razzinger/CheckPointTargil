resource "aws_ecs_service" "web" {
  name            = "web-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.web.arn
  launch_type     = "EC2"

  load_balancer {
    elb_name       = aws_elb.classic_elb.name
    container_name = "web-container"
    container_port = 80
  }

  desired_count = 2
}
