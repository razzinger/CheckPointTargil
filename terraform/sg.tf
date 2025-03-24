resource "aws_security_group" "lb_sg" {
    name        = "elb-sg"
    description = "Security group for the Load Balancer"
    vpc_id      = aws_vpc.main.id

    # Allow incoming HTTP traffic
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow all outgoing traffic
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "checkpoint targil elb security group"
    }
}

resource "aws_security_group" "ecs_sg" {
    vpc_id = aws_vpc.main.id

    ingress {
        from_port   = 8081
        to_port     = 8081
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "checkpoint targil ecs_sg security group"
    }
}
