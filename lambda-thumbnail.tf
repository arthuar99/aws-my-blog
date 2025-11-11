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


resource "aws_lambda_function" "thumbnail" {
  function_name = "myblog-thumbnail"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_exec.arn

  filename         = data.archive_file.thumbnail_function.output_path
  source_code_hash = data.archive_file.thumbnail_function.output_base64sha256

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.photos.bucket
    }
  }
}

resource "aws_lambda_permission" "allow_s3_invoke_thumbnail" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.thumbnail.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.photos.arn
}



resource "aws_s3_bucket_notification" "photos_upload" {
  bucket = aws_s3_bucket.photos.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.thumbnail.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3_invoke_thumbnail]
}
