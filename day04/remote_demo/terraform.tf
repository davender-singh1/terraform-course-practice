terraform {

required_providers {
	aws = {
	source = "hashicorp/aws"
	version = "4.66.1"
}
}

backend "s3" {
	bucket = "terraweek-demo-state-bucket-136649"
	key = "terraform.tfstate"
	region = "us-east-1"
	dynamodb_table = "terrafweek-demo-state-table136649"
}
}
