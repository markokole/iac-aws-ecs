output aws_security_group_id {
  value = data.aws_security_group.default.id
}

output public_ip {
    value = module.ec2_cluster.public_ip
}

output vpc_cidr_block {
  value = module.vpc.vpc_cidr_block
}
