provider "aws" {
	region = "us-east-1"
}

resource "aws_instance" "my_ec2_instance" {
	count = 2
	ami = "ami-0c7217cdde317cfec"
        instance_type = "t2.micro"
	tags = {
	Name = "terraweek-instance"
}
}
