# Lambda function posts
resource "aws_lambda_function" "api_posts_handler" {
  function_name = "myblog-api-posts"
  role          = aws_iam_role.lambda_api.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"

  filename         = "${path.module}/lambda/api_posts_function.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda/api_posts_function.zip")

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.posts_table.name
    }
  }
}
