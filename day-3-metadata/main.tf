terraform {
required_providers {
	aws = {
	source = "hashicorp/aws"
	version = "~> 4.16"
}
}
	required_version = ">= 1.2.0"
}

provider "aws" {
	region = "us-east-1"
}

locals {
	instances = {"Devender":"ami-079db87dc4c10ac91","Daven":"ami-0c7217cdde317cfec","Mohit":"ami-0c7217cdde317cfec","Monu":"ami-079db87dc4c10ac91"}
}

resource "aws_instance" "aws_ec2_test" {
        for_each = local.instances
        ami = each.value
        instance_type = "t2.micro"
        tags = {
     Name = each.key
  }
}

