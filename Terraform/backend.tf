terraform {
  backend "s3" {
    bucket  = "YOURBUCKETNAME"
    key     = "actionspipeline1000/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
