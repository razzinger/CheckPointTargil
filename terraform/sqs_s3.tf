resource "aws_sqs_queue" "my_queue" {
  name = var.sqs_name
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
  acl = "private"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.terraform_bucket_name
  acl = "private"
}
