resource "aws_s3_bucket" "codepipeline_artifacts" {
  bucket        = "tf-sample-codepipeline-artifacts"
  force_destroy = true

  tags = {
    Name = "Terraform-sample-codepipeline-artifacts"
  }
}

output "s3_artifacts" {
  value = aws_s3_bucket.codepipeline_artifacts.arn
}

output "s3_codepipeline_artifacts" {
  value = aws_s3_bucket.codepipeline_artifacts.id
}
