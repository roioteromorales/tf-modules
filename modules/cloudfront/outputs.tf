output "cloudfront_url" {
  value = "https://${aws_cloudfront_distribution.main.domain_name}"
}

output "url" {
  value = "https://${local.sub_domain}"
}

output "distribution_id" {
  value = aws_cloudfront_distribution.main.id
}

output "bucket_arn" {
  value = aws_s3_bucket.main.arn
}

output "bucket_name" {
  value = aws_s3_bucket.main.bucket
}

output "bucket_domain_name" {
  value = aws_s3_bucket.main.bucket_domain_name
}
