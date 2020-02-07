data "aws_route53_zone" "website_zone" {
  name         = var.route53_zone
  private_zone = false
}
resource "aws_route53_record" "web" {
  zone_id = data.aws_route53_zone.website_zone.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}