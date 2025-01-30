terraform {
  backend "s3" {
    bucket = "step-project-3-bucket"
    key    = "terraform/state"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}
