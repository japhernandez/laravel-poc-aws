resource "aws_security_group" "alb" {
  name   = "alb-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 9000
    to_port     = 9000
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
    Name = "ALB-sg"
  }
}

resource "aws_lb" "alb" {
  name                             = "tf-sample-alb"
  load_balancer_type               = "network"
  # security_groups    = [aws_security_group.alb.id]
  subnets                          = aws_subnet.publics[*].id
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "tf-sample-alb"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.backend.id
  }

  lifecycle {
    ignore_changes = [
      default_action,
    ]
  }
}
