variable "s3_codepipeline_artifacts" {
  description = "The codepipeline artifacts bucket"
}

variable "connection_github" {
  description = "The connection source github"
}

variable "github_repository" {
  description = "The repository github"
}

variable "github_branch" {
  description = "The repository branch"
}

variable "codebuild_project" {
  description = "The codebuild project"
}

variable "ecs_cluster_id" {
  description = "The ecs cluster id"
}

variable "ecs_services_id" {
  description = "The ecs services id"
}