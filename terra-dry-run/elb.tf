resource "aws_elb" "classic_elb" {
  name               = "my-classic-elb"
  availability_zones = [var.aws_zone]
  subnets            = [aws_subnet.public.id, aws_subnet.private.id]
  security_groups    = [aws_security_group.elb_sg.id]

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
