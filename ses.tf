# Lambda Welcome Email 
resource "aws_lambda_function" "welcome_email_sender" {
  function_name = "myblog-welcome-email"
  role          = aws_iam_role.lambda_ses.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"

  filename         = data.archive_file.welcome_email.output_path
  source_code_hash = data.archive_file.welcome_email.output_base64sha256
  environment {
    variables = {
      SES_EMAIL = "YOUR_VERIFIED_EMAIL@domain.com"
    }
  }
}
