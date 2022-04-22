module "network" {
  source = "../../infra/network"

  project     = var.project
  environment = var.environment
}

module "application" {
  source = "../../infra/application"

  project                     = var.project
  region                      = var.aws_region
  environment                 = var.environment
  ecs_container_image         = var.ecs_container_image
  twitter_consumer_key        = var.twitter_consumer_key
  twitter_consumer_secret     = var.twitter_consumer_secret
  twitter_access_token        = var.twitter_access_token
  twitter_access_token_secret = var.twitter_access_token_secret
  vpc_id                      = module.network.vpc_id
  public_subnet_ids           = module.network.public_subnet_ids
  private_subnet_ids          = module.network.private_subnet_ids
}
