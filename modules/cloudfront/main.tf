locals {
  s3_origin_id = var.subdomain
  bucket_name = "${var.subdomain}.${var.domain_name}-${data.aws_caller_identity.current.account_id}"
  sub_domain = "${var.subdomain}.${var.domain_name}"
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "main" {
  bucket = local.bucket_name
  acl = "private"
  force_destroy = true
  versioning {
    enabled = true
  }
  tags = {
    Name = local.bucket_name
  }
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.main.json
}

data "aws_iam_policy_document" "main" {
  statement {
    actions = [
      "s3:GetObject"]
    resources = [
      "${aws_s3_bucket.main.arn}/*"
    ]
    principals {
      type = "AWS"
      identifiers = [
        aws_cloudfront_origin_access_identity.main.iam_arn
      ]
    }
  }

  statement {
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.main.arn
    ]
    principals {
      type = "AWS"
      identifiers = [
        aws_cloudfront_origin_access_identity.main.iam_arn
      ]
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "main" {
  comment = var.subdomain
}

resource "aws_cloudfront_distribution" "main" {
  depends_on = [
    aws_cloudfront_origin_access_identity.main,
    aws_s3_bucket.main]

  enabled = true
  wait_for_deployment = false
  is_ipv6_enabled = true

  price_class = var.price_class
  default_root_object = var.default_root_object

  # If using route53 aliases for DNS we need to declare it here too, otherwise we'll get 403s.
  aliases = [
    local.sub_domain]

  origin {
    domain_name = aws_s3_bucket.main.bucket_regional_domain_name
    origin_id = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.main.cloudfront_access_identity_path
    }
  }

  custom_error_response {
    error_caching_min_ttl = 3000
    error_code = 404
    response_code = 200
    response_page_path = var.error_response_page_path
  }

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
    target_origin_id = local.s3_origin_id
    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS"
    ]
    cached_methods = [
      "GET",
      "HEAD"
    ]

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method = "vip"
  }
}

data "aws_route53_zone" "selected" {
  name = var.domain_name
}

resource "aws_route53_record" "main" {
  depends_on = [
    aws_cloudfront_distribution.main
  ]
  zone_id = data.aws_route53_zone.selected.zone_id
  name = local.sub_domain
  type = "A"
  alias {
    name = aws_cloudfront_distribution.main.domain_name
    zone_id = aws_cloudfront_distribution.main.hosted_zone_id
    evaluate_target_health = true
  }
}
