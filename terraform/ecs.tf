# Define ECS Cluster
resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster"
}

# Task Definition for Frontend Service
resource "aws_ecs_task_definition" "frontend" {
  family = "frontend"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = aws_iam_role.ecs_task_role.arn
  cpu = "256"
  memory = "512"
  network_mode = "awsvpc"

  container_definitions = jsonencode([
    {
      name = "frontend-container"
      image = "romanzinger75/chk-targil:frontend-latest"
      essential = true
      portMappings = [
        {
          containerPort = 8081
          hostPort = 8081 # host port is ignored in fargate, but keep it for consistency
          protocol = "tcp"
        }
      ]
    }
  ])
}

# Task Definition for Backend Service
resource "aws_ecs_task_definition" "backend" {
  family = "backend"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = aws_iam_role.ecs_task_role.arn
  cpu = "256"
  memory = "512"
  network_mode = "awsvpc"

  container_definitions = jsonencode([
    {
      name = "backend-container"
      image = "romanzinger75/chk-targil:backend-latest"
      essential = true
    }
  ])
}

# ECS Service for Frontend (With Load Balancer)
resource "aws_ecs_service" "frontend" {
  name = "frontend-service"
  cluster = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.frontend.arn
  desired_count = 1
  launch_type = "FARGATE"
  force_new_deployment = true

  network_configuration {
    subnets = [aws_subnet.private.id]
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_frontend.arn
    container_name   = "frontend-container"
    container_port   = 8081
  }
}

# ECS Service for Backend (NO Load Balancer)
resource "aws_ecs_service" "backend" {
  name = "backend-service"
  cluster = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count = 1
  launch_type = "FARGATE"
  force_new_deployment = true

  network_configuration {
    subnets = [aws_subnet.private.id]
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = false # Backend is private, reachable only within VPC
  }
}
