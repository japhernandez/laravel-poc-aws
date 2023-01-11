resource "aws_codestarconnections_connection" "github_app" {
  name          = "github-connection"
  provider_type = "GitHub"
}

output "connection_name" {
  value = aws_codestarconnections_connection.github_app.arn
}