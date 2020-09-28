variable "cidr_block" {
  default = "172.18.0.0/16"
}

variable "managedby" {
  default = "Terraform"
}

variable "environment" {
  default = "dev"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of Public Subnets in the VPC"
  default     = ["Public_Subnet1", "Public_Subnet2"]
}

variable "private_subnets" {
  type        = list(string)
  description = "List of Public Subnets in the VPC"
  default     = ["Private_Subnet1", "Private_Subnet2"]
}