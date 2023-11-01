provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

locals {
  name   = "coderview-vpc"
  region = "eu-west-2"

  vpc_cidr = "10.0.0.0/16"
  azs      = data.aws_availability_zones.available.names

  tags = {
    Envirnoment = "dev"
    Project     = "coderview"
  }
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = local.name
  cidr = local.vpc_cidr

  azs = local.azs

  public_subnets   = [for k in range(0, 2) : cidrsubnet("10.0.0.0/16", 4, k)]
  private_subnets  = [for k in range(0, 2) : cidrsubnet("10.0.0.0/16", 4, k + 2)]
  database_subnets = [for k in range(0, 2) : cidrsubnet("10.0.0.0/16", 4, k + 4)]

  public_subnet_names         = ["coderview-Public-Subnet-One", "coderview-Public-Subnet-Two"]
  private_subnet_names        = ["coderview-Private-Subnet-One", "coderview-Private-Subnet-Two"]
  database_subnet_names       = ["coderview-DB-Subnet-One", "coderview-DB-Subnet-Two"]
  default_security_group_tags = { Name = "coderview-Security-Group" }
  igw_tags                    = { Name = "coderview-Internet-Gateway" }
  nat_gateway_tags            = { Name = "coderview-Nat-Gateway" }
  nat_eip_tags                = { Name = "coderview-EIP" }


  create_database_subnet_group  = true
  manage_default_network_acl    = false
  manage_default_route_table    = false
  manage_default_security_group = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true



  enable_vpn_gateway = false

  enable_dhcp_options              = true
  dhcp_options_domain_name         = "service.consul"
  dhcp_options_domain_name_servers = ["127.0.0.1", "10.10.0.2"]

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60

  tags = local.tags
}

