resource "aws_s3_bucket" "artifacts" {
  bucket = "github-terraform-cicd-artifacts-${random_id.rand.hex}"
}

resource "random_id" "rand" {
  byte_length = 4
}

resource "aws_iam_role" "codepipeline_role" {
  name = "github-codepipeline-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "codepipeline.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_codepipeline" "cicd" {
  name     = "github-terraform-cicd"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.artifacts.bucket
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
        ConnectionArn    = var.github_connection_arn
        FullRepositoryId = var.github_repo_fullname
        BranchName       = var.github_branch
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"
      configuration = {
        ProjectName = aws_codebuild_project.app_build.name
      }
    }
  }

  stage {
    name = "TerraformPlan"
    action {
      name             = "TerraformPlan"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["tfplan_output"]
      version          = "1"
      configuration = {
        ProjectName = aws_codebuild_project.terraform_plan.name
      }
    }
  }

  stage {
    name = "ManualApproval"
    action {
      name      = "ApproveChange"
      category  = "Approval"
      owner     = "AWS"
      provider  = "Manual"
      version   = "1"
    }
  }

  stage {
    name = "TerraformApply"
    action {
      name             = "TerraformApply"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      version          = "1"
      configuration = {
        ProjectName = aws_codebuild_project.terraform_apply.name
      }
    }
  }
}
