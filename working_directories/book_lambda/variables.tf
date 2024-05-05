variable "environment" {
  type = string
  default = "test"
}

variable "owner" {
  type = string
  default = "matias"
}

variable "lambda_role_name" {
  type = string
  default = "mati_test_lambda_role"
}

variable "book_version" {
  type = string
  default = "1_0_0"
}