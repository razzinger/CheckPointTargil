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
}
