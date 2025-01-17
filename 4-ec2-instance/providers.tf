terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "5.83.1"
    }
  }
}


provider "aws" {
  region = "ap-south-1"

  default_tags {
    tags = {
        demo = "kubesimplify-opentofu-workshop"
    }
  }
}