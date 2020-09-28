module "networking" {
  source = "../../modules/networking"
}

output "public_subnet_ids" {
    value = module.networking.public_subnet_ids
}