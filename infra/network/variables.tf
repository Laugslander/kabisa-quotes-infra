variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.16.0/20", "10.0.48.0/20", "10.0.80.0/20"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.0.0/20", "10.0.32.0/20", "10.0.64.0/20"]
}
