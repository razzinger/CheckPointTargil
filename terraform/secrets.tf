# Create AWS Secrets Manager secret
resource "aws_secretsmanager_secret" "sqs_s3_secret" {
  name = "my-sqs-s3-secrets"
}

# Store values in the secret
resource "aws_secretsmanager_secret_version" "sqs_s3_secret_value" {
  secret_id     = aws_secretsmanager_secret.sqs_s3_secret.id
  secret_string = jsonencode({
    VALID_TOKEN   = "your-secure-token"
    SQS_QUEUE_URL = aws_sqs_queue.my_queue.id
    S3_BUCKET_NAME = aws_s3_bucket.my_bucket.id
  })
}

# IAM policy to allow ECS tasks to read secrets
resource "aws_iam_policy" "secrets_access" {
  name        = "ECSSecretsAccess"
  description = "Allow ECS tasks to read secrets"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["secretsmanager:GetSecretValue"]
      Resource = aws_secretsmanager_secret.sqs_s3_secret.arn
    }]
  })
}
