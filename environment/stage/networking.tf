module "networking" {
  source      = "../../modules/networking"
  cidr_block  = "172.19.0.0/16"
  environment = "stage"
}