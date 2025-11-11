# Package Lambda sources into ZIPs without committing binaries
# Thumbnail generator

data "archive_file" "thumbnail" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/thumbnail"
  output_path = "${path.module}/lambda/build/thumbnail_function.zip"
}

# API posts handler

data "archive_file" "api_posts" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/api_posts"
  output_path = "${path.module}/lambda/build/api_posts_function.zip"
}

# Welcome email sender

data "archive_file" "welcome_email" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/welcome_email"
  output_path = "${path.module}/lambda/build/welcome_email_function.zip"
}
