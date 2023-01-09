resource "aws_ecr_repository" "backend" {
  name = "backend"
}

resource "aws_iam_role" "backend_task_execution_role" {
  name = "backend-task-execution-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "backend_task_execution_policy_attachment" {
  role       = aws_iam_role.backend_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


#resource "aws_iam_role_policy" "backend_task_rds_secret_access" {
#  name = "backend-task-rds-secret-access"
#  role = aws_iam_role.backend_task_execution_role.id
#
#  policy = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Effect": "Allow",
#      "Action": [
#        "secretsmanager:GetSecretValue"
#      ],
#      "Resource": [
#        "${aws_secretsmanager_secret.rds_secret.arn}*"
#      ]
#    }
#  ]
#}
#EOF
#}

resource "aws_ecs_task_definition" "backend" {
  family                   = "backend"
  execution_role_arn       = aws_iam_role.backend_task_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  # Fargate has specific cpu and memory combinations
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size
  cpu    = 256
  memory = 512

  container_definitions = <<DEFINITION
[
  {
    "essential": true,
    "image": "${aws_ecr_repository.backend.repository_url}",
    "name": "demo",
    "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
               "awslogs-group" : "demo",
               "awslogs-region": "${var.aws_region}",
               "awslogs-stream-prefix": "ecs"
            }
     },
     "secrets": [],
     "environment": [],
     "healthCheck": {
       "command": [ "CMD-SHELL", "curl -f http://localhost:9000/api/ || exit 1" ],
       "interval": 30,
       "retries": 3,
       "timeout": 5
     },
     "portMappings": [
        {
           "containerPort": 9000,
           "hostPort": 9000,
           "protocol": "tcp"
        }
     ]
  }
]
DEFINITION

#  container_definitions = templatefile("${abspath(path.root)}/../backend/taskdef.json", {
#    BACKEND_IMAGE_PATH = aws_ecr_repository.backend.repository_url
#    NGINX_IMAGE_PATH   = aws_ecr_repository.nginx.repository_url
#    DB_HOST            = aws_db_instance.db.address
#    DB_PORT            = aws_db_instance.db.port
#    DB_DATABASE        = aws_db_instance.db.name
#    DB_USERNAME        = "${aws_secretsmanager_secret.rds_secret.arn}:username::"
#    DB_PASSWORD        = "${aws_secretsmanager_secret.rds_secret.arn}:password::"
#  })
}
#
#resource "aws_service_discovery_service" "backend" {
#  name = "backend"
#
#  dns_config {
#    namespace_id   = aws_service_discovery_private_dns_namespace.discovery.id
#    routing_policy = "MULTIVALUE"
#
#    dns_records {
#      ttl  = 15
#      type = "A"
#    }
#  }
#}

resource "aws_security_group" "backend_task" {
  name   = "backend-task-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 9000
    to_port         = 9000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "backend-task-sg"
  }
}

resource "aws_ecs_service" "backend" {
  name                               = "backend"
  cluster                            = aws_ecs_cluster.cluster.id
  task_definition                    = aws_ecs_task_definition.backend.arn
  launch_type                        = "FARGATE"
  deployment_minimum_healthy_percent = 50
  desired_count                      = 2

  network_configuration {
    subnets         = aws_subnet.apps[*].id
    security_groups = [aws_security_group.backend_task.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.backend.id
    container_name   = "backend"
    container_port   = 9000
  }

  lifecycle {
    ignore_changes = [task_definition, load_balancer]
  }

#  service_registries {
#    registry_arn = aws_service_discovery_service.backend.arn
#  }

  depends_on = [aws_lb.alb]
}

resource "aws_alb_target_group" "backend" {
  name        = "backend-tg"
  port        = 9000
  protocol    = "TCP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"

  health_check {
    healthy_threshold   = 3
    interval            = 120
    protocol            = "TCP"
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb_listener.http.arn
  port     = 80
  protocol = "TCP"

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

resource "aws_codebuild_project" "backend" {
  name         = "backend"
  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "./backend/buildspec.yml"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:3.0"
    type         = "LINUX_CONTAINER"

    // Use privileged mode otherwise build errors out when building image:
    // Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
    // See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project#privileged_mode
    privileged_mode = true

    environment_variable {
      name  = "AWS_REGION"
      value = var.aws_region
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.id
    }

    environment_variable {
      name  = "BACKEND_REPOSITORY_URL"
      value = aws_ecr_repository.backend.repository_url
    }
  }
}
