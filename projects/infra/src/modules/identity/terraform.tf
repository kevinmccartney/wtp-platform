locals {
  environments = tomap({
    "prod" = {
      "name"        = "wtp_users_prod"
      "external_id" = var.sns_external_id_prod
    },
    "dev" = {
      "name"        = "wtp_users_dev"
      "external_id" = var.sns_external_id_dev
    },
  })
}

# Trust relationships policy document
data "aws_iam_policy_document" "sns_assume_role_policy" {
  for_each = local.environments
  version  = "2012-10-17"

  statement {
    sid = "wtp${title(each.key)}SnsRole"

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"

      values = [each.value.external_id]
    }
  }
}

data "aws_iam_policy_document" "sns_role_policy" {
  for_each = local.environments
  version  = "2012-10-17"

  statement {
    sid = "wtp${title(each.key)}SnsRolePolicy"

    actions = [
      "sns:publish"
    ]
    resources = ["arn:aws:sns:::*"]
  }
}

resource "aws_iam_policy" "sms_policy" {
  for_each = local.environments

  name        = "${each.value.name}-SMS-Policy"
  path        = "/ServiceRole/"
  description = "Policy for SNS SMS role"

  policy = data.aws_iam_policy_document.sns_role_policy[each.key].json

  tags = {
    "project"     = "we-the-party",
    "managed_by"  = "terraform"
    "environment" = each.key
  }
}

resource "aws_iam_role_policy_attachment" "sms_role_policy_attachment" {
  for_each = local.environments

  role       = aws_iam_role.sms_role[each.key].name
  policy_arn = aws_iam_policy.sms_policy[each.key].arn

  tags = {
    "project"     = "we-the-party",
    "managed_by"  = "terraform"
    "environment" = each.key
  }
}

resource "aws_iam_role" "sms_role" {
  for_each = local.environments

  name               = "${each.value.name}-SMS-Role"
  path               = "/ServiceRole/"
  assume_role_policy = data.aws_iam_policy_document.sns_assume_role_policy[each.key].json

  tags = {
    "project"     = "we-the-party",
    "managed_by"  = "terraform"
    "environment" = each.key
  }
}

# resource "aws_cognito_user_pool" "user_pool" {
#   for_each  = local.environments

#   name                     = each.value.name
#   auto_verified_attributes = [
#     "email",
#     "phone_number",
#   ]
#   email_configuration {
#     email_sending_account = "COGNITO_DEFAULT"
#   }
#   schema {
#     attribute_data_type      = "String"
#     developer_only_attribute = false 
#     mutable                  = true 
#     name                     = "email" 
#     required                 = true 

#     string_attribute_constraints {
#       max_length = "2048" 
#       min_length = "0" 
#     }
#   }
#   schema {
#     attribute_data_type      = "String"
#     developer_only_attribute = false
#     mutable                  = true
#     name                     = "family_name"
#     required                 = true

#     string_attribute_constraints {
#       max_length = "2048"
#       min_length = "0"
#     }
#   }
#   schema {
#     attribute_data_type      = "String"
#     developer_only_attribute = false
#     mutable                  = true
#     name                     = "given_name"
#     required                 = true

#     string_attribute_constraints {
#       max_length = "2048"
#       min_length = "0"
#     }
#   }
#   schema {
#     attribute_data_type      = "String"
#     developer_only_attribute = false
#     mutable                  = true
#     name                     = "phone_number"
#     required                 = true

#     string_attribute_constraints {
#       max_length = "2048"
#       min_length = "0"
#     }
#   }
#   schema {
#     attribute_data_type      = "String"
#     developer_only_attribute = false
#     mutable                  = true
#     name                     = "preferred_username"
#     required                 = true

#     string_attribute_constraints {
#         max_length = "2048"
#         min_length = "0"
#     }
#   }
#   mfa_configuration          = "OPTIONAL"

#   sms_authentication_message = "Your authentication code is {####}. "
#   sms_configuration {
#     external_id    = each.value.external_id
#     sns_caller_arn = aws_iam_role.sms_role[each.key].arn
#   }


#   tags = {
#     "project"     = "we-the-party",
#     "managed_by"  = "terraform"
#     "environment" = each.key
#   }
# }

# output "sms_role" {
#   value = aws_iam_role.sms_role
# }

# resource "aws_cognito_identity_pool" "identity_pool" {
#   for_each = local.environments

#   name = each.value.name
# }


# clients?
