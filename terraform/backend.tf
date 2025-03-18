terraform {
    backend "s3" {
        bucket = "chkpoint-targil-bucket-terraform"
        key    = "terraform/state/my-terraform.tfstate"   # Path in the S3 bucket where the state file will be stored
        region = "eu-north-1"
    }
}
