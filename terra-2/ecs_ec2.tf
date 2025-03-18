resource "aws_ecs_cluster" "main" {
  name = "my-ecs-cluster"
}

resource "aws_launch_configuration" "ecs" {
  name          = "ecs-launch-config"
  image_id      = "ami-0c55b159cbfafe1f0" # Update to ECS optimized AMI
  instance_type = "t2.micro"
  key_name      = "my-key"
  security_groups = [aws_security_group.ecs_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${aws_ecs_cluster.main.name} >> /etc/ecs/ecs.config
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs" {
  launch_configuration = aws_launch_configuration.ecs.id
  vpc_zone_identifier  = [aws_subnet.public.id]
  min_size             = 1
  max_size             = 3
  desired_capacity     = 2

  tag {
    key                 = "Name"
    value               = "ECS-Instance"
    propagate_at_launch = true
  }
}
