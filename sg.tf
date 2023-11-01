module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  use_name_prefix = false
  name            = "coderview-Security-Group-One"
  description     = "Security group with SSH and HTTP rules"
  vpc_id          = module.vpc.vpc_id

  # Ingress Rules (Allow SSH and HTTP for IPv4)
  ingress_cidr_blocks = ["152.58.194.25/32"]
  ingress_rules       = ["ssh-tcp","http-80-tcp"]

  # Egress Rules (Allow All Outbound Traffic for IPv4)
  egress_cidr_blocks      = ["0.0.0.0/0"]
  egress_rules            = ["all-all"]
  egress_ipv6_cidr_blocks = []

  tags = local.tags
}

module "security_group-2" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  use_name_prefix = false
  name            = "coderview-Security-Group-Two"
  description     = "Security group with all traffic"
  vpc_id          = module.vpc.vpc_id

  # Ingress Rules (Allow all inbound traffic for IPv4)
  ingress_cidr_blocks = ["10.0.0.0/16"]
  ingress_rules       = ["all-all"]

  # Egress Rules (Allow all outbound traffic for IPv4)
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
  egress_ipv6_cidr_blocks = []


  tags = local.tags
}

module "security_group-3" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  use_name_prefix = false
  name            = "coderview-Security-Group-RDS"
  description     = "Security group with all traffic"
  vpc_id          = module.vpc.vpc_id

  # Ingress Rules (Allow all inbound traffic for IPv4)
  ingress_cidr_blocks = ["10.0.0.0/16"]
  ingress_rules       = ["postgresql-tcp","ssh-tcp"]

  # Egress Rules (Allow all outbound traffic for IPv4)
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
  egress_ipv6_cidr_blocks = []


  tags = local.tags
}
