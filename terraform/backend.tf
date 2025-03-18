terraform {
    backend "s3" {
        bucket = var.terraform_bucket_name
        key    = "terraform/state/my-terraform.tfstate"   # Path in the S3 bucket where the state file will be stored
        region = var.aws_region
    }
}
