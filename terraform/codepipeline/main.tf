resource "aws_iam_role" "codepipeline" {
  name = "terraform-sample-codepipeline"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_codepipeline" "pipeline" {
  name     = "terraform-sample-pipeline"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = var.s3_codepipeline_artifacts
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = var.connection_github
        FullRepositoryId = var.github_repository
        BranchName       = var.github_branch
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "backend-build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["backend_build_output"]
      version          = 1

      configuration = {
        ProjectName = var.codebuild_project
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name     = "backend-deploy"
      category = "Deploy"
      owner    = "AWS"
      provider = "ECS"
      version  = 1

      configuration = {
        ClusterName = var.ecs_cluster_id
        ServiceName = var.ecs_services_id
        FileName    = "imagedefinitions.json"
      }

      input_artifacts = ["backend_build_output"]
    }
  }
}

