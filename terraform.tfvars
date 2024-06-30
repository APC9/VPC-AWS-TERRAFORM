# Generic Variables
tags = {
  "env"         = "development"
  "owner"       = "apc"
  "cloud"       = "AWS"
  "IAC"         = "Terraform"
  "IAC_VERSION" = "1.8.1"
  "proyect"     = "AWS-LABS"
  "region"      = "virginia"
}

region     = "us-east-1"
enviroment = "DEV"
owners     = "AWS"

# VPC Variables
name        = "AWS-LABS"
cidr        = "192.168.0.0/22"
network_acl = "NACL-AWS-LAB"
route_table = "RT-AWS-LAB"
azs         = ["us-east-1a"]

internet_gateway = "IGW-AWS_LABS"

public_subnets      = ["192.168.0.0/24"]
public_subnets_name = "SUBNET-PUBLIC"

private_subnets      = ["192.168.1.0/24", "192.168.2.0/23"]
private_subnets_name = "SUBNET-PRIVATE"

enable_nat_gateway = false
enable_vpn_gateway = false

#Ec2 Instance
instance_type = "t2.micro"
ec2_ami = "ami-0bb84b8ffd87024d8"
key_name = "AWS-LABS"

# Default Inbound ACL Rules
# Bloquear los puertos especificos par el trafico entrante
inbound_acl_rules = [
  {
    "action" : "allow",
    "cidr_block" : "0.0.0.0/0",
    "from_port" : 0,
    "protocol" : "-1",
    "rule_no" : 100,
    "to_port" : 0
  }
]

# Defaut Outbound ACL Rules
# permitir el trafico saliente de todos los puertos
outbound_acl_rules = [
  {
    "action" : "allow",
    "cidr_block" : "0.0.0.0/0",
    "from_port" : 0,
    "protocol" : "-1",
    "rule_no" : 100,
    "to_port" : 0
  }
]

# public Inbound ACL Rules
public_inbound_acl_rules = [
  {
    "protocol" : "tcp",
    "rule_number" : 100,
    "rule_action" : "allow",
    "cidr_block" : "0.0.0.0/0",
    "from_port" : 80,
    "to_port" : 80
  },
  {
    "protocol" : "tcp",
    "rule_number" : 200,
    "rule_action" : "allow",
    "cidr_block" : "0.0.0.0/0",
    "from_port" : 22,
    "to_port" : 22
  },
  {
    "protocol" : "tcp",
    "rule_number" : 300,
    "rule_action" : "allow",
    "cidr_block" : "0.0.0.0/0",
    "from_port" : 443,
    "to_port" : 443
  },
  {
    "protocol" : "tcp",
    "rule_number" : 400,
    "rule_action" : "allow",
    "cidr_block" : "0.0.0.0/0",
    "from_port" : 1024,
    "to_port" : 65535
  }
]

# public Outbound ACL Rules
public_outbound_acl_rules = [
  {
    "protocol" : "tcp",
    "rule_number" : 100,
    "rule_action" : "allow",
    "cidr_block" : "0.0.0.0/0",
    "from_port" : 80,
    "to_port" : 80
  },
  {
    "protocol" : "tcp",
    "rule_number" : 200,
    "rule_action" : "allow",
    "cidr_block" : "0.0.0.0/0",
    "from_port" : 22,
    "to_port" : 22
  },
  {
    "protocol" : "tcp",
    "rule_number" : 300,
    "rule_action" : "allow",
    "cidr_block" : "0.0.0.0/0",
    "from_port" : 443,
    "to_port" : 443
  },
  {
    "protocol" : "tcp",
    "rule_number" : 400,
    "rule_action" : "allow",
    "cidr_block" : "0.0.0.0/0",
    "from_port" : 1024,
    "to_port" : 65535
  }
]

# private Inbound ACL Rules
private_inbound_acl_rules = [
  {
    "protocol" : "tcp",
    "rule_number" : 100,
    "rule_action" : "allow",
    "cidr_block" : "0.0.0.0/0",
    "from_port" : 22,
    "to_port" : 22
  },
  {
    "protocol" : "tcp",
    "rule_number" : 200,
    "rule_action" : "allow",
    "cidr_block" : "0.0.0.0/0",
    "from_port" : 80,
    "to_port" : 80
  },
  {
    "protocol" : "tcp",
    "rule_number" : 300,
    "rule_action" : "allow",
    "cidr_block" : "0.0.0.0/0",
    "from_port" : 443,
    "to_port" : 443
  },
  {
    "protocol" : "tcp",
    "rule_number" : 400,
    "rule_action" : "allow",
    "cidr_block" : "0.0.0.0/0",
    "from_port" : 1024,
    "to_port" : 65535
  }
]

# private Outbound ACL Rules
private_outbound_acl_rules = [
  {
    "protocol" : "tcp",
    "rule_number" : 100,
    "rule_action" : "allow",
    "cidr_block" : "0.0.0.0/0",
    "from_port" : 22,
    "to_port" : 22
  },
  {
    "protocol" : "tcp",
    "rule_number" : 200,
    "rule_action" : "allow",
    "cidr_block" : "0.0.0.0/0",
    "from_port" : 80,
    "to_port" : 80
  },
  {
    "protocol" : "tcp",
    "rule_number" : 300,
    "rule_action" : "allow",
    "cidr_block" : "0.0.0.0/0",
    "from_port" : 443,
    "to_port" : 443
  },
  {
    "protocol" : "tcp",
    "rule_number" : 400,
    "rule_action" : "allow",
    "cidr_block" : "0.0.0.0/0",
    "from_port" : 1024,
    "to_port" : 65535
  }
]


# Security group ingress rules
security_group_name = "APP-SEG-AWS-LAB"
security_group_rules_ingress = [
  {
    cidr_blocks = "0.0.0.0/0"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "OPEN TO PORT 22 - SSH"
  },
  {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
    description = "OPEN TO PORT 80 - HTTP"
  },
]

security_group_rules_egress = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "0.0.0.0/0"
    description = "OPEN TO PORT 22 - SSH"
  }
]