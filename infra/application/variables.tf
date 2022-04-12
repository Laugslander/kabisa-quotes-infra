variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "ecs_desired_count" {
  type    = number
  default = 1
}

variable "ecs_autoscaling_max_capacity" {
  type    = number
  default = 1
}

variable "ecs_autoscaling_min_capacity" {
  type    = number
  default = 1
}

variable "ecs_minimum_healthy_percent" {
  type    = number
  default = 50
}

variable "ecs_maximum_healthy_percent" {
  type    = number
  default = 200
}

variable "ecs_health_check_grace_period_seconds" {
  type    = number
  default = 240
}

variable "ecs_container_image" {
  type = string
}

variable "ecs_container_port" {
  type    = number
  default = 8080
}

variable "ecs_task_cpu" {
  type    = number
  default = 256
}

variable "ecs_task_memory" {
  type    = number
  default = 512
}

variable "ecs_memory_asg_target_value" {
  type    = number
  default = 80
}

variable "ecs_memory_asg_scale_in_cooldown" {
  type    = number
  default = 300
}

variable "ecs_memory_asg_scale_out_cooldown" {
  type    = number
  default = 300
}

variable "ecs_cpu_asg_target_value" {
  type    = number
  default = 60
}

variable "ecs_cpu_asg_scale_in_cooldown" {
  type    = number
  default = 300
}

variable "ecs_cpu_asg_scale_out_cooldown" {
  type    = number
  default = 300
}

variable "twitter_integration_enabled" {
  type    = bool
  default = true
}

variable "twitter_consumer_key" {
  type = string
}

variable "twitter_consumer_secret" {
  type = string
}

variable "twitter_access_token" {
  type = string
}

variable "twitter_access_token_secret" {
  type = string
}