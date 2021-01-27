terraform {
  backend "s3" {}
}

data "terraform_remote_state" "state" {
  backend = "s3"
  config = {
    bucket         = "wtp-web-state"
    dynamodb_table = "wtp-web-${var.wtp_environment}-state-locks"
    region         = var.wtp_aws_region
    key            = "${var.wtp_environment}/terraform.tfstate"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "wtp-web-${var.wtp_environment}-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

provider "aws" {
  version = "~> 2.8"
  region  = var.wtp_aws_region
}

module "web_prod" {
  source = "../modules/s3_distribution"

  environment = var.wtp_environment
}
