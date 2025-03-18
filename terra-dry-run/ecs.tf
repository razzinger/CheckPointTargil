resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster"
}

resource "aws_ecs_task_definition" "frontend" {
    family                   = "frontend"
    requires_compatibilities = ["FARGATE"]
    execution_role_arn       = aws_iam_role.ecs_task_role.arn
    cpu                      = "256"
    memory                   = "512"
    network_mode             = "awsvpc"
    container_definitions    = jsonencode([
        {
            name      = "frontend-container"
            image     = "your_frontend_image:latest"
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

resource "aws_ecs_task_definition" "backend" {
    family                   = "backend"
    requires_compatibilities = ["FARGATE"]
    execution_role_arn       = aws_iam_role.ecs_task_role.arn
    cpu                      = "256"
    memory                   = "512"
    network_mode             = "awsvpc"
    container_definitions    = jsonencode ([
        {
            name      = "backend-container"
            image     = "your_backend_image:latest" # Replace with actual image
            essential = true
            portMappings = [
                {
                    containerPort = 8080  # Replace with actual port used by your backend
                    hostPort      = 8080
                }
            ]
        }
    ])
}
