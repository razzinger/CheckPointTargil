resource "aws_lb" "main" {
    name               = "main-elb"
    internal           = false
    load_balancer_type = "network"
    subnets            = [aws_subnet.public.id, aws_subnet.private.id]
    security_groups    = [aws_security_group.elb_sg.id]
}

resource "aws_lb_target_group" "ecs_frontend" {
    name     = "ecs-frontend-tg"
    port     = 80
    protocol = "TCP"
    vpc_id   = aws_vpc.main.id
}
