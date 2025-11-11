resource "aws_dynamodb_table" "posts_table" {
  name         = "blog-posts"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

# Create custom DAX parameter group
resource "aws_dax_parameter_group" "blog_posts_dax_params" {
  name        = "blog-posts-dax-params"
  description = "DAX parameter group for blog posts cache"
}

# Create DAX cluster and reference the custom parameter group
resource "aws_dax_cluster" "blog_posts_dax" {
  cluster_name         = "blog-posts-dax"
  node_type            = "dax.t3.small"
  replication_factor   = 1
  iam_role_arn         = aws_iam_role.dax_role.arn
  parameter_group_name = aws_dax_parameter_group.blog_posts_dax_params.name

  server_side_encryption {
    enabled = true
  }
}
