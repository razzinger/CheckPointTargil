variable "aws_region" {
  description = "AWS region"
  default     = "eu-north-1"
}

variable "aws_zone" {
  description = "AWS zone"
  default     = "eu-north-1a"
}

variable "sqs_name" {
  description = "The name of the SQS"
  default     = "chkpoint-targil-sqs"
}

variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  default     = "chkpoint-targil-bucket"
}
