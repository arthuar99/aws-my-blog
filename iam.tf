# Lambda API role
resource "aws_iam_role" "lambda_api" {
  name = "lambda-api-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}
resource "aws_iam_role_policy_attachment" "lambda_api_dynamodb" {
  role       = aws_iam_role.lambda_api.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

# Lambda SES role
resource "aws_iam_role" "lambda_ses" {
  name = "lambda-ses-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}
resource "aws_iam_role_policy_attachment" "lambda_ses_send" {
  role       = aws_iam_role.lambda_ses.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}

# DAX role (if you're using DAX)
resource "aws_iam_role" "dax_role" {
  name = "dax-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "dax.amazonaws.com" }
    }]
  })
}

# Lambda Thumbnail role
resource "aws_iam_role" "lambda_thumbnail" {
  name = "lambda-thumbnail-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_thumbnail_s3" {
  role       = aws_iam_role.lambda_thumbnail.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_thumbnail_basic" {
  role       = aws_iam_role.lambda_thumbnail.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
