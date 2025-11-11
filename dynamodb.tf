resource "aws_dynamodb_table" "posts_table" {
  name         = "blog-posts"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}


resource "aws_dax_cluster" "blog_posts_dax" {
  cluster_name       = "blog-posts-dax"
  node_type          = "dax.t2.small"
  replication_factor = 1
  iam_role_arn       = aws_iam_role.dax_role.arn

  server_side_encryption {
    enabled = true
  }
  parameter_group_name = "default.dax1.0"
}
