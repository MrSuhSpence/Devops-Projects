terraform {
  backend "s3" {
    bucket  = "one-million1"
    key     = "actionspipeline1000/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
