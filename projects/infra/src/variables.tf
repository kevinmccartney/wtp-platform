variable "wtp_aws_region" {
  type = string
  description = "The AWS region in which our serverless resources reside"
}

variable "wtp_sns_external_id_dev" {
  type = string
  description = "The external dev id for SNS"
}

variable "wtp_sns_external_id_prod" {
  type = string
  description = "The external prod id for SNS"
}
