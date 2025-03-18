resource "aws_sqs_queue" "my_queue" {
  name = var.sqs_name
}

resource "aws_s3_bucket_acl" "my_bucket" {
  bucket = var.bucket_name
  acl    = "private"
}
