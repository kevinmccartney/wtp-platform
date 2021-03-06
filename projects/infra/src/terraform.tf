terraform {
  backend "s3" {}
}

data "terraform_remote_state" "state" {
  backend = "s3"
  config = {
    bucket     = "wtp-infra-state"
    lock_table = "wtp-infra-state-locks"
    region     = var.wtp_aws_region
    key        = "terraform.tfstate"
  }
}

provider "aws" {
  version = "~> 2.8"
  region = var.wtp_aws_region
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "wtp-infra-state"
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
  name         = "wtp-infra-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

module "web_certs" {
  source = "./modules/cert"

  domain_names = tomap({
    "apex"   = "wethe.party"
    "api"    = "api.wethe.party",
  })
}

# module "identity" {
#   source = "./modules/identity"
#   external_id_dev = var.wtp_external_id_dev
#   external_id_prod = var.wtp_external_id_prod
# }

# output "sms_role" {
#   value = module.identity.sms_role
# }
