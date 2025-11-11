output "static_website_url" {
  value = aws_cloudfront_distribution.static.domain_name
}

output "api_url" {
  value = "${aws_api_gateway_rest_api.blog_api.execution_arn}/prod"
}

output "photo_bucket" {
  value = aws_s3_bucket.photos.bucket
}

output "thumbnails_bucket" {
  value = aws_s3_bucket.thumbnails.bucket
}
