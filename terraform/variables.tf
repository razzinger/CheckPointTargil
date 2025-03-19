variable "aws_region" {
  description = "AWS region"
  default     = "eu-north-1"
}

variable "aws_zone_1" {
  description = "AWS zone"
  default     = "eu-north-1a"
}

variable "aws_zone_2" {
  description = "AWS zone"
  default     = "eu-north-1b"
}

variable "sqs_name" {
  description = "SQS for targil"
  default     = "chkpoint-targil-sqs"
}

variable "bucket_name" {
  description = "S3 bucket for targil"
  default     = "chkpoint-targil-bucket"
}
