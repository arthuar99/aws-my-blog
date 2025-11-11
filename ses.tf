# Lambda Welcome Email 
resource "aws_lambda_function" "welcome_email_sender" {
  function_name = "myblog-welcome-email"
  role          = aws_iam_role.lambda_ses.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"

  filename         = "${path.module}/lambda/welcome_email_function.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda/welcome_email_function.zip")
  environment {
    variables = {
      SES_EMAIL = "YOUR_VERIFIED_EMAIL@domain.com"
    }
  }
}
