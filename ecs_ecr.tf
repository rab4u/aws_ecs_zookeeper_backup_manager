# CHECK AND GET THE IMAGE URL FROM ECR
data "aws_ecr_repository" "service" {
  name = var.ecr_repo_name
}

# PUSH THE IMAGE TO THE ECR
module "ecs-ecr" {
  source          = "./terraform_modules/ecr_module"
  image_name      = var.ecr_repo_name
  tag             = var.ecr_image_tag
  source_path     = "./docker"
  repository_url  = data.aws_ecr_repository.service.repository_url
  enable_image_push = var.enable_image_push
}