terraform {
	required_providers {
	aws = {
	source  = "hashicorp/aws"
        version = "~>4.16"
}
}
required_version = ">= 1.2.0"
}

provider "aws" {
	region = "us-east-1"
}

resource "aws_security_group" "my_ec2_instance" {
  name_prefix = "web-server-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_ec2_instance" {
	count = 5
	ami = "ami-08c40ec9ead489470"
	key_name = "terraform-key"
	instance_type = "t2.micro"
	security_groups = [aws_security_group.my_ec2_instance.name]
	tags = {
		Name = "TerraformCourse"
}
}

resource "aws_s3_bucket" "my_s3_bucket" {
	bucket = "terraform-davender1366-123"
	tags = {
	Name = "terraform-davender1366-123"
        Environment = "Dev"
}
}

output "ec2_public_ips" {
	value = aws_instance.my_ec2_instance[*].public_ip
}

