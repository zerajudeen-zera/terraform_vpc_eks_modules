terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "6.27.0"
    }
  }
  backend "s3" {
    bucket = "myterraformbucket"
    region = "us-east-1"
    use_lockfile = true
    key = "terraform/backend/terraform.tfstate"
  }
}

provider "aws" {
    region = "us-east-1"
  
}