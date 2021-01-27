resource "aws_route53_zone" "domain_routes" {
  name = "wethe.party"
  tags = {
    "project"    = "we-the-party",
    "managed_by" = "terraform"
  }
}

resource "aws_acm_certificate" "default" {
  domain_name               = var.domain_names["apex"]
  subject_alternative_names = [for name in var.domain_names : "*.${name}"]
  validation_method         = "DNS"
  tags = {
    "project"    = "we-the-party",
    "managed_by" = "terraform"
  }
  options {
    certificate_transparency_logging_preference = "ENABLED"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation" {
  depends_on = [aws_acm_certificate.default]

  for_each = {
    for dvo in aws_acm_certificate.default.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.domain_routes.zone_id

  tags = {
    "project"    = "we-the-party",
    "managed_by" = "terraform"
  }
}

resource "aws_acm_certificate_validation" "default" {
  certificate_arn = aws_acm_certificate.default.arn

  validation_record_fqdns = [for validation in aws_route53_record.validation : validation.fqdn]

  tags = {
    "project"    = "we-the-party",
    "managed_by" = "terraform"
  }
}