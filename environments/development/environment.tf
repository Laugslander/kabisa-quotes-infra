module "network" {
  source = "../../infra/network"

  project     = var.project
  environment = var.environment
}

module "application" {
  source = "../../infra/application"

  project             = var.project
  region              = var.aws_region
  environment         = var.environment
  ecs_container_image = var.ecs_container_image
  vpc_id              = module.network.vpc_id
  public_subnet_ids   = module.network.public_subnet_ids
}
