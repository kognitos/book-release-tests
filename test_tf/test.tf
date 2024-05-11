terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "mati-test-terraform-bucket"
    key    = "test.tfstate"
    region = "us-west-2"
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "example" {
  bucket = "my-mati-tf-test-bucket"
}

output "lambda_name" {
  value = aws_s3_bucket.example.bucket
}

output "lambda_arn" {
  value = aws_s3_bucket.example.arn
}
