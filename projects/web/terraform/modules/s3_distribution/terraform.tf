locals {
  s3_bucket_name = var.environment == "prod" ? "wethe.party" : "${var.environment}.wethe.party"
}

data "aws_acm_certificate" "cert" {
  domain   = "wethe.party"
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "route_zone" {
  name = "wethe.party"
}

resource "aws_s3_bucket" "web_dist" {
  bucket = var.environment == "prod" ? "wethe.party" : "${var.environment}.wethe.party"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_policy" "dist_bucket" {
  bucket = aws_s3_bucket.web_dist.id
  
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${local.s3_bucket_name}/*"
            ]
        }
    ]
}  
POLICY
}

resource "aws_route53_record" "cname_route_record" {
  count = var.environment == "prod" ? 0 : 1
  zone_id = data.aws_route53_zone.route_zone.zone_id
  name    = local.s3_bucket_name
  type    = "CNAME"
  ttl     = "300"
  records = [aws_cloudfront_distribution.s3_distribution.domain_name]
}

resource "aws_route53_record" "alias_route_record" {
  count = var.environment == "prod" ? 1 : 0

  zone_id = data.aws_route53_zone.route_zone.zone_id
  name    = "wethe.party"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.web_dist.website_endpoint
    origin_id   = "wtp-web-${var.environment}"

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = [
          "TLSv1",
          "TLSv1.1",
          "TLSv1.2",
        ]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Managed by Terraform"

  aliases = [var.environment == "prod" ? "wethe.party" : "${var.environment}.wethe.party"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "wtp-web-${var.environment}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    "project" = "can-i-munch",
    "managed_by" = "terraform"
    "environment" = var.environment
  }

  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.cert.arn
    ssl_support_method  = "sni-only"
  }
}
