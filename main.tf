terraform {
  backend "s3" {
    bucket = "step-project-3"
    key    = "terraform/state"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}
