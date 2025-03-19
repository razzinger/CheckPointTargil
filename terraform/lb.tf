resource "aws_lb" "alb" {
  name               = "my-application-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb_sg.id]
  subnets            = [aws_subnet.public.id]

  enable_deletion_protection = false

  tags = {
    Name = "Application-ALB"
  }
}

# Target group for the frontend service
resource "aws_lb_target_group" "ecs_frontend" {
  name        = "ecs-frontend-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip" # Important for Fargate
}

# Target group for the backend service
resource "aws_lb_target_group" "ecs_backend" {
  name        = "ecs-backend-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip" # Important for Fargate
}

# ALB Listener to route traffic to the frontend target group
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_frontend.arn
  }
}
