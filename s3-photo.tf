
resource "aws_s3_bucket" "photos" {
  bucket        = "myblog-photos-${random_id.bucket_id.hex}"
  force_destroy = true
}



resource "aws_s3_bucket" "thumbnails" {
  bucket        = "myblog-thumbnails-${random_id.bucket_id.hex}"
  force_destroy = true
}
