module "website_cert" {
  providers = {
    aws = aws.east
  }
  source = "terraform-aws-modules/acm/aws"

  domain_name = var.route53_zone
  zone_id     = data.aws_route53_zone.website_zone.zone_id

  subject_alternative_names = [ "*.${var.route53_zone}" ]

  wait_for_validation = true

  tags = {
    Name = var.route53_zone
  }
}
