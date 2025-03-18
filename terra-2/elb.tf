resource "aws_elb" "classic_elb" {
  name               = "my-classic-elb"
  availability_zones = var.aws_zone

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

  instances = aws_autoscaling_group.ecs.instances

  idle_timeout                = 60
  connection_draining         = true
  connection_draining_timeout = 300

  tags = {
    Name = "Classic-ELB"
  }
}

resource "aws_lb_target_group" "ecs_frontend" {
  name     = "ecs-frontend-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id
}
