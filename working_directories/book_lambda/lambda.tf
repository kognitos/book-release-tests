terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "terraform-mati-tests"
    region = "us-west-2"
  }
}

provider "aws" {
  region = "us-west-2"
}

data "archive_file" "lambda_source_code" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function_payload.zip"
}

data "aws_iam_role" "lambda_role" {
  name = var.lambda_role_name
}

resource "aws_lambda_function" "book_lambda" {
  filename      = "lambda_function_payload.zip"
  function_name = "mati-test-lambda-${var.book_version}"
  role          = data.aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  source_code_hash = data.archive_file.lambda_source_code.output_base64sha256

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }

  tags = {
    environment = var.environment
    owner       = var.owner
    version     = var.book_version
  }
}
