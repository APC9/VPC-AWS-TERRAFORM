module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.0"

  #Details
  name = "${var.name}-${local.name}"
  cidr = var.cidr
  azs  = var.azs

  #public subnet
  public_subnets       = var.public_subnets
  public_subnet_suffix = var.public_subnets_name

  #private subnet
  private_subnets         = var.private_subnets
  private_subnet_suffix   = var.private_subnets_name
  map_public_ip_on_launch = true # Indicar que la ec2 lanzadas en un subred de le deba asignar un direccion IP publica

  #Route Table VPC
  default_route_table_name = var.route_table

  #Route Table public
  private_route_table_tags = {
    Name = "${var.route_table}-PRIVATE"
  }

  public_route_table_tags = {
    Name = "${var.route_table}-PUBLIC"
  }

  #Internet Gateway
  igw_tags = {
    Name = var.internet_gateway
  }

  # Network ACL
  default_network_acl_name    = var.network_acl
  default_network_acl_ingress = var.inbound_acl_rules
  default_network_acl_egress  = var.outbound_acl_rules

  # Public network ACL
  public_dedicated_network_acl = true
  public_inbound_acl_rules     = var.public_inbound_acl_rules
  public_outbound_acl_rules    = var.public_outbound_acl_rules
  public_acl_tags = {
    Name = "PUBLIC-ACL"
  }

  # Private network ACL
  private_dedicated_network_acl = true
  private_inbound_acl_rules     = var.private_inbound_acl_rules
  private_outbound_acl_rules    = var.private_outbound_acl_rules
  private_acl_tags = {
    Name = "PRIVATE-ACL"
  }

  #Security Group Rules
  default_security_group_name    = var.security_group_name
  default_security_group_ingress = var.security_group_rules_ingress
  default_security_group_egress  = var.security_group_rules_egress

  # Disabled Nat gateway and VPN gateway
  enable_nat_gateway = var.enable_nat_gateway
  enable_vpn_gateway = var.enable_vpn_gateway


  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_instance" "public_instance" {
  ami                    = var.ec2_ami
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = module.vpc.default_vpc_default_security_group_id
  key_name               = var.key_name
  #tenancy                = "dedicated"



  user_data = <<-EOF
                  #!/bin/bash
                  # Utiliza esto para tus datos de usuario
                  # Instala httpd (Version: Linux 2)
                  sudo yum update -y

                  sudo mkdir /mnt/efs
                  sudo yum install -y amazon-efs-utils
                  mount -t efs ${aws_efs_file_system.AWS-EFS-LABS.id}:/ /mnt/efs

                  sudo yum install -y httpd
                  systemctl start httpd
                  systemctl enable httpd
                  echo "<h1>Hola Mundo desde $(hostname -f)</h1>" > /var/www/html/index.html
                EOF 

  tags = {
    Name = "AWS-LABS-PUBLIC-EC2"
    DLM  = true
  }
}

# Crear y adjuntar volumen EBS a instancia publica
resource "aws_ebs_volume" "ebs_public_ec2" {
  availability_zone = var.azs[0]
  type              = "gp3"
  size              = 10
  encrypted         = true
  kms_key_id        = aws_kms_key.kms_ebs_pb.arn

  tags = {
    Name = "AWS-EBS-EC2-PB"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs_public_ec2.id
  instance_id = aws_instance.public_instance.id
}

# Crear y Habilitar cifrado de volumen EBS
resource "aws_kms_key" "kms_ebs_pb" {
  description = "KMS key for EBS encrytion instance ec2 public"
}

resource "aws_kms_alias" "kms_alias_ebs_pb" {
  name          = "alias/aws-ebs"
  target_key_id = aws_kms_key.kms_ebs_pb.id
}

# Realizar snapshot a Volumen EBs publico 
resource "aws_ebs_snapshot" "ebs-snapshot" {
  volume_id = aws_ebs_volume.ebs_public_ec2.id

  tags = {
    Name = "AWS-EBS-SNAPSHOT"
  }
}

resource "aws_instance" "private_instance" {
  ami                    = var.ec2_ami
  instance_type          = var.instance_type
  subnet_id              = module.vpc.private_subnets[1]
  vpc_security_group_ids = module.vpc.default_vpc_default_security_group_id
  key_name               = var.key_name

  user_data = <<-EOF
                  #!/bin/bash
                  # Utiliza esto para tus datos de usuario
                  # Instala httpd (Version: Linux 2)
                  sudo yum update -y

                  sudo mkdir /mnt/efs
                  sudo yum install -y amazon-efs-utils
                  mount -t efs ${aws_efs_file_system.AWS-EFS-LABS.id}:/ /mnt/efs

                  sudo yum install -y httpd
                  systemctl start httpd
                  systemctl enable httpd
                  echo "<h1>Hola Mundo desde $(hostname -f)</h1>" > /var/www/html/index.html
                EOF 

  tags = {
    Name = "AWS-LABS-private-EC2"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"

  tags = {
    Name = "AWS-VPC-ENDPOINT"
  }
}

resource "aws_vpc_endpoint_policy" "policy" {
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowAll",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "*",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_vpc_endpoint_route_table_association" "vpc_endpoint_route_table_association" {
  for_each        = { for idx, route_table_id in module.vpc.private_route_table_ids : idx => route_table_id }
  route_table_id  = each.value
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}



resource "aws_s3_bucket" "s3_bucket" {
  bucket = "aws-s3-bucket-apc-lab"

  tags = {
    Name = "AWS-LABS-S3-APC91"
  }
}


# Configuracion de Data LifeCycle manager
# Esto es para crear Snapshot de los volumenes EBS de manera automatica
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["dlm.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "dlm_lifecycle_role" {
  name               = "dlm-lifecycle-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "dlm_lifecycle" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateSnapshot",
      "ec2:CreateSnapshots",
      "ec2:DeleteSnapshot",
      "ec2:DescribeInstances",
      "ec2:DescribeVolumes",
      "ec2:DescribeSnapshots",
    ]

    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["ec2:CreateTags"]
    resources = ["arn:aws:ec2:*::snapshot/*"]
  }
}

resource "aws_iam_role_policy" "dlm_lifecycle" {
  name   = "dlm-lifecycle-policy"
  role   = aws_iam_role.dlm_lifecycle_role.id
  policy = data.aws_iam_policy_document.dlm_lifecycle.json
}

resource "aws_dlm_lifecycle_policy" "AWS-DLM-LBS" {
  description        = "Hourly for 4 hours"
  execution_role_arn = aws_iam_role.dlm_lifecycle_role.arn
  state              = "ENABLED"

  policy_details {
    resource_types = ["INSTANCE"]

    schedule {
      name = "backup-ec2"

      create_rule {
        interval      = 1         #EVERY
        interval_unit = "HOURS"   #frequency
        times         = ["18:00"] # starting at
      }

      retain_rule {
        count = 3 # retetion type
      }

      tags_to_add = {
        DLM = true
      }

      copy_tags = true
    }

    target_tags = {
      DLM = "EC2"
    }
  }
}

# Crear un EFS
resource "aws_efs_file_system" "AWS-EFS-LABS" {
  creation_token         = "my-efs-token-aws-lab"
  encrypted              = true
  availability_zone_name = var.azs[0]

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "AWS-EFS"
  }
}

resource "aws_efs_mount_target" "AWS-EFS-MOUNT-TARGET" {
  file_system_id  = aws_efs_file_system.AWS-EFS-LABS.id
  subnet_id       = module.vpc.public_subnets[0]
  security_groups = [module.vpc.default_security_group_id]
}