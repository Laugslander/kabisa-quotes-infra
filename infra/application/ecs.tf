resource "aws_cloudwatch_log_group" "main" {
  name = "/ecs/${var.project}-task-${var.environment}"
}

locals {
  default_ecs_task_environment = [
    { name : "SPRING_PROFILES_ACTIVE", value : "aws" }
  ]

  ecs_task_environment = length(var.ecs_task_environment) > 0 ? local.default_ecs_task_environment : concat(local.default_ecs_task_environment, var.ecs_task_environment)
}

resource "aws_ecs_task_definition" "main" {
  family                   = "${var.project}-task-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions    = jsonencode([
    {
      name         = "${var.project}-container-${var.environment}"
      image        = var.ecs_container_image
      essential    = true
      environment  = local.ecs_task_environment
      portMappings = [
        {
          protocol      = "tcp"
          containerPort = var.ecs_container_port
          hostPort      = var.ecs_container_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options   = {
          awslogs-group         = aws_cloudwatch_log_group.main.name
          awslogs-stream-prefix = "ecs"
          awslogs-region        = var.region
        }
      }
    }
  ])

}

resource "aws_ecs_cluster" "main" {
  name = "${var.project}-cluster-${var.environment}"
}

resource "aws_ecs_service" "main" {
  name                               = "${var.project}-service-${var.environment}"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.main.arn
  desired_count                      = var.ecs_desired_count
  deployment_minimum_healthy_percent = var.ecs_minimum_healthy_percent
  deployment_maximum_percent         = var.ecs_maximum_healthy_percent
  health_check_grace_period_seconds  = var.ecs_health_check_grace_period_seconds
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = var.public_subnet_ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.main.arn
    container_name   = "${var.project}-container-${var.environment}"
    container_port   = var.ecs_container_port
  }

  lifecycle {
    // Ignore desired count due to autoscaling rules
    ignore_changes = [desired_count]
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.ecs_autoscaling_max_capacity
  min_capacity       = var.ecs_autoscaling_min_capacity
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = var.ecs_memory_asg_target_value
    scale_in_cooldown  = var.ecs_memory_asg_scale_in_cooldown
    scale_out_cooldown = var.ecs_memory_asg_scale_out_cooldown
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = var.ecs_cpu_asg_target_value
    scale_in_cooldown  = var.ecs_cpu_asg_scale_in_cooldown
    scale_out_cooldown = var.ecs_cpu_asg_scale_out_cooldown
  }
}
