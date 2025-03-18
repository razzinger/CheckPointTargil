resource "aws_elb" "classic_elb" {
  name               = "my-classic-elb"
  internal           = false
  security_groups    = [aws_security_group.elb_sg.id]
  subnets            = [aws_subnet.public.id]

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  idle_timeout                = 60
  connection_draining         = true
  connection_draining_timeout = 300

  tags = {
    Name = "Classic-ELB"
  }
}

resource "aws_lb_target_group" "ecs_frontend" {
  name        = "ecs-frontend-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
}
