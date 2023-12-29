resource "aws_s3_bucket" "my_s3_bucket" {
	bucket = "terraweek-demo-state-bucket-136649"
}

resource "aws_dynamodb_table" "my_dynamo_table" {
	name = "terrafweek-demo-state-table136649"
	billing_mode = "PAY_PER_REQUEST"
	hash_key = "LockID"
	attribute {
	name = "LockID"
	type = "S"
	}
}
