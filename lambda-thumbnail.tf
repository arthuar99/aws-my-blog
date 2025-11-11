resource "aws_lambda_function" "thumbnail_generator" {
  function_name = "myblog-thumbnail-generator"
  runtime       = "python3.12"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda_thumbnail.arn

  filename         = data.archive_file.thumbnail.output_path
  source_code_hash = data.archive_file.thumbnail.output_base64sha256

  environment {
    variables = {
      THUMBNAIL_BUCKET = aws_s3_bucket.thumbnails.bucket
    }
  }
}


resource "aws_s3_bucket_notification" "photos_upload" {
  bucket = aws_s3_bucket.photos.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.thumbnail_generator.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = ""
    filter_suffix       = ".jpg"
  }
}
