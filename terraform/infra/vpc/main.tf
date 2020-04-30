data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.name
  cidr = "10.0.0.0/16"

  azs             = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  enable_nat_gateway = true
  enable_vpn_gateway = true
  enable_dns_hostnames = true
  single_nat_gateway = true
  enable_ec2_endpoint              = true
  ec2_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_security_group_rule" "ssh_uma" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["192.136.74.93/32"]
  security_group_id = data.aws_security_group.default.id
}


module "ec2_cluster" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = "${var.name}-cluster"
  instance_count         = var.launch_test_ec2

  ami                    = "ami-0b7a46b4bd694e8a6" # Amazon Linux 2 AMI 2.0.20200406.0 x86_64 HVM gp2
  instance_type          = "t3.micro"
  key_name               = "terraform-ecs"
  monitoring             = true
  associate_public_ip_address = true
  vpc_security_group_ids = [data.aws_security_group.default.id]
  subnet_ids             = module.vpc.public_subnets

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# resource "aws_eip_association" "eip_assoc" {
#   instance_id   = element(module.ec2_cluster.id, 0)
#   allocation_id = module.vpc.nat_ids[0]
# }