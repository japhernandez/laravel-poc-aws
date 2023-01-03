resource "aws_security_group" "alb" {
  name   = "alb-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB-sg"
  }
}

resource "aws_lb" "alb" {
  name               = "tf-sample-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.publics[*].id

  tags = {
    Name = "tf-sample-alb"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.frontend.arn
  }
}

resource "aws_alb_target_group" "frontend" {
  name        = "frontend-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"

  health_check {
    healthy_threshold   = 3
    interval            = 30
    protocol            = "HTTP"
    matcher             = 200
    timeout             = 3
    path                = "/"
    unhealthy_threshold = 2
  }
}
