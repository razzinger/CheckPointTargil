variable "aws_region" {
  description = "AWS zone"
  default     = "eu-north-1"
}

variable "sqs_name" {
  description = "The name of the SQS"
  default     = "chkpoint-targil-sqs"
}

variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  default     = "chkpoint-targil-bucket"
}

variable "terraform_bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  default     = "chkpoint-targil-bucket-terraform"
}
