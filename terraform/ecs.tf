# Define ECS Cluster
resource "aws_ecs_cluster" "my_cluster" {
    name = "my-cluster"
}

# Task Definition for Frontend Service
resource "aws_ecs_task_definition" "frontend" {
    family                   = "frontend"
    requires_compatibilities = ["FARGATE"]
    execution_role_arn       = aws_iam_role.ecs_task_role.arn
    cpu                      = "256"
    memory                   = "512"
    network_mode             = "awsvpc"

    container_definitions = jsonencode([
        {
            name  = "frontend-container"
            image = "your_frontend_image:latest"    # Replace with actual image
            essential = true
            portMappings = [
                {
                    containerPort = 80
                    hostPort      = 80
                }
            ]
        }
    ])
}

# Task Definition for Backend Service
resource "aws_ecs_task_definition" "backend" {
    family                   = "backend"
    requires_compatibilities = ["FARGATE"]
    execution_role_arn       = aws_iam_role.ecs_task_role.arn
    cpu                      = "256"
    memory                   = "512"
    network_mode             = "awsvpc"

    container_definitions = jsonencode([
        {
            name  = "backend-container"
            image = "your_backend_image:latest"     # Replace with actual image
            essential = true
            portMappings = [
                {
                    containerPort = 8080  # Adjust based on backend service needs
                    hostPort      = 8080
                }
            ]
        }
    ])
}

# ECS Service for Frontend
resource "aws_ecs_service" "frontend" {
    name            = "frontend-service"
    cluster         = aws_ecs_cluster.my_cluster.id
    task_definition = aws_ecs_task_definition.frontend.arn
    desired_count   = 1
    launch_type     = "FARGATE"

    network_configuration {
        subnets          = [aws_subnet.private.id]
        security_groups  = [aws_security_group.ecs_sg.id]
        assign_public_ip = false
    }

    load_balancer {
        target_group_arn = aws_lb_target_group.ecs_frontend.arn
        container_name   = "frontend-container"
        container_port   = 80
    }
}

# ECS Service for Backend
resource "aws_ecs_service" "backend" {
    name            = "backend-service"
    cluster         = aws_ecs_cluster.my_cluster.id
    task_definition = aws_ecs_task_definition.backend.arn
    desired_count   = 1
    launch_type     = "FARGATE"

    network_configuration {
        subnets          = [aws_subnet.private.id]
        security_groups  = [aws_security_group.ecs_sg.id]
        assign_public_ip = false
    }

    load_balancer {
        target_group_arn = aws_lb_target_group.ecs_backend.arn
        container_name   = "backend-container"
        container_port   = 8080
    }
}
