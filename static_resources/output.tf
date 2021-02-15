output "s3_bucket_name" {
  value = var.s3_bucket_name
}

output "ecr_repo_url" {
  value = aws_ecr_repository.create_ecr_repo.repository_url
}