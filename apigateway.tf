resource "aws_api_gateway_rest_api" "blog_api" {
  name        = "myblog-rest-api"
  description = "REST API for MyBlog dynamic content"
}

resource "aws_api_gateway_resource" "posts" {
  rest_api_id = aws_api_gateway_rest_api.blog_api.id
  parent_id   = aws_api_gateway_rest_api.blog_api.root_resource_id
  path_part   = "posts"
}

resource "aws_api_gateway_method" "get_posts" {
  rest_api_id   = aws_api_gateway_rest_api.blog_api.id
  resource_id   = aws_api_gateway_resource.posts.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "posts_get_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.blog_api.id
  resource_id             = aws_api_gateway_resource.posts.id
  http_method             = aws_api_gateway_method.get_posts.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api_posts_handler.invoke_arn
}


resource "aws_api_gateway_deployment" "api_deploy" {
  rest_api_id = aws_api_gateway_rest_api.blog_api.id
  depends_on  = [aws_api_gateway_integration.posts_get_lambda]
}

#  Use this instead of stage_name in deployment
resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.api_deploy.id
  rest_api_id   = aws_api_gateway_rest_api.blog_api.id
  stage_name    = "prod"
}
