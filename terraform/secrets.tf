# Create AWS Secrets Manager secret
resource "aws_secretsmanager_secret" "sqs_s3_secrets" {
  name = "sqs-s3-secrets_ver01"
}

resource "random_string" "token" {
  length  = 22
  special = false
}

# Store values in the secret
resource "aws_secretsmanager_secret_version" "sqs_s3_secret_value" {
  secret_id     = aws_secretsmanager_secret.sqs_s3_secrets.id
  secret_string = jsonencode({
    VALID_TOKEN    = "${random_string.token.result}"
    SQS_QUEUE_URL  = aws_sqs_queue.my_queue.id
    S3_BUCKET_NAME = aws_s3_bucket.my_bucket.id
  })
}
