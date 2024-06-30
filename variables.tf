# Goblal tags
variable "tags" {
  description = "tags del proyecto"
  type        = map(string)
}

# AWS Region
variable "region" {
  description = "Region in which AWS resources to be created"
  type        = string
  default     = ""
}

# Environment Variable
variable "enviroment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = ""
}

# Business Division
variable "owners" {
  description = "Organization this Infraestructure belongs"
  type        = string
  default     = ""
}

# VPC variables defined as below
# VPC Name
variable "name" {
  description = "VPC Name"
  type        = string
  default     = "vpc"
}

# VPC CIDR Block
variable "cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

# VPC Availability Zones
variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = ["eu-west-2a"]
}

# VPC Public Subnets
variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "public_subnets_name" {
  description = "Suffix to append to public subnets name"
  type        = string
  default     = ""
}

# VPC Private Subnets
variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_name" {
  description = "Suffix to append to private subnets name"
  type        = string
  default     = ""
}

# VPC Enable NAT Gateway (True or False) 
variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = true
}

# VPC Single NAT Gateway (True or False)
variable "enable_vpn_gateway" {
  description = "Should be true if you want to provision a single VPN Gateway"
  type        = bool
  default     = true
}

# Network acl name 
variable "network_acl" {
  description = "Network acl name"
  type        = string
  default     = ""
}

# Route_table_name
variable "route_table" {
  description = "Route table name"
  type        = string
  default     = ""
}

# Internet Gateway name
variable "internet_gateway" {
  description = "Internet Gateway name"
  type        = string
  default     = ""
}

# Inbound ACL Rules
variable "inbound_acl_rules" {
  description = "Inbound ACL Rules"
  type        = list(map(string))
}

# Outbound ACL Rules
variable "outbound_acl_rules" {
  description = "Outbound ACL Rules"
  type        = list(map(string))
}

# Private Inbound ACL Rules
variable "private_inbound_acl_rules" {
  description = "Inbound ACL Rules"
  type        = list(map(string))
}

# private Outbound ACL Rules
variable "private_outbound_acl_rules" {
  description = "Outbound ACL Rules"
  type        = list(map(string))
}

# public Inbound ACL Rules
variable "public_inbound_acl_rules" {
  description = "Inbound ACL Rules"
  type        = list(map(string))
}

# public Outbound ACL Rules
variable "public_outbound_acl_rules" {
  description = "Outbound ACL Rules"
  type        = list(map(string))
}

# Security group ingress Rules
variable "security_group_rules_ingress" {
  description = "Security group ingress Rules"
  type        = list(map(string))
}

# Security group egress Rules
variable "security_group_rules_egress" {
  description = "Security group ingress Rules"
  type        = list(map(string))
}

# Security group name
variable "security_group_name" {
  description = "Security group name"
  type        = string
  default     = ""
}

# EC2 instance 
variable "instance_type" {
  description = "instance type"
  type        = string
}

variable "ec2_ami" {
  description = "EC2 ami"
  type        = string
}

variable "key_name" {
  description = "key name"
  type        = string
}