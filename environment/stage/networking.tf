module "networking" {
  source      = "../../modules/networking"
  cidr_block  = var.vpc_cidr_block
  environment = var.environment
}