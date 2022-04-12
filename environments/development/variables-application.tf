variable "ecs_container_image" {
  type = string
}

variable "ecs_task_environment" {
  type    = list(map(string))
  default = [{}]
}
