output "artifact_bucket" { value = aws_s3_bucket.artifacts.id }
output "codecommit_repo_clone_url" { value = aws_codecommit_repository.repo.clone_url_http }