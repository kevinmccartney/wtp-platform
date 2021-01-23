terraform {
  backend "s3" {}
}

data "terraform_remote_state" "state" {
  backend = "s3"
  config = {
    bucket     = "cim-web-state"
    dynamodb_table = "cim-web-${var.cim_environment}-state-locks"
    region     = var.cim_aws_region
    key        = "${var.cim_environment}/terraform.tfstate"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "cim-web-state"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "cim-web-${var.cim_environment}-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

provider "aws" {
  version = "~> 2.8"
  region = var.cim_aws_region
}

module "web_dev" {
  source = "../modules/s3_distribution"

  environment = var.cim_environment
}
