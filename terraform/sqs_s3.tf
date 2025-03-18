resource "aws_sqs_queue" "my_queue" {
  name = var.sqs_name
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
  region = var.aws_region
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.terraform_bucket_name
  region = var.aws_region
}
