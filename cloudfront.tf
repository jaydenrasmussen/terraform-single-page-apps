locals {
  s3_origin_id = "${var.domain_name}_bucket"
}

resource "aws_cloudfront_origin_access_identity" "default" {
  comment = "${var.domain_name} Access Identity"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  depends_on      = [module.website_cert]
  comment         = "${var.domain_name} CDN"
  enabled         = true
  is_ipv6_enabled = true
  http_version    = "http2"

  default_root_object = "index.html"
  aliases             = [var.domain_name]
  price_class         = "PriceClass_100"

  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    target_origin_id = local.s3_origin_id
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    compress         = true


    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  custom_error_response {
    error_code         = "404"
    response_code      = 200
    response_page_path = "/index.html"
  }


  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = module.website_cert.this_acm_certificate_arn
    ssl_support_method             = "sni-only"
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}