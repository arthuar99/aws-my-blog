resource "aws_s3_bucket" "static_website" {
  bucket        = "myblog-static-site-${random_id.bucket_id.hex}"
  force_destroy = true
}

# New: Move the website configuration to a separate resource
resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
