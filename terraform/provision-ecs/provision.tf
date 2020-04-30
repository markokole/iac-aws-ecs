locals {
    name = "marko-ecs"
}

module "vpc" {
    source            = "../infra/vpc"

    name              = local.name
    launch_test_ec2   = 0
}

module "ecs" {
    source            = "../infra/ecs"

    name              = local.name
}