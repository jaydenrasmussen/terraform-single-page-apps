output "cdn_id" {
  value       = aws_cloudfront_distribution.s3_distribution.id
  description = "Cloudfront Distribution Id for invalidations"
}
output "s3_bucket_name" {
  value       = aws_s3_bucket.website.id
  description = "S3 Bucket name for uploading files to"
}
