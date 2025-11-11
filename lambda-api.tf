# Lambda function posts
resource "aws_lambda_function" "api_posts_handler" {
  function_name = "myblog-api-posts"
  role          = aws_iam_role.lambda_api.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"

  filename         = data.archive_file.api_posts.output_path
  source_code_hash = data.archive_file.api_posts.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.posts_table.name
    }
  }
}
