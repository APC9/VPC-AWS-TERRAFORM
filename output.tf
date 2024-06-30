# VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# VPC CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

# VPC Private Subnets
output "private_subnets" {
  description = "A list of private subnets inside the VPC"
  value       = module.vpc.private_subnets_cidr_blocks
}

# VPC Public Subnets
output "public_subnets" {
  description = "A list of public subnets inside the VPC"
  value       = module.vpc.public_subnets_cidr_blocks
}

output "public_subnets_id" {
  description = "A list of public subnets inside the VPC"
  value       = module.vpc.public_subnets
}

# VPC AZs
output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value       = module.vpc.azs
}