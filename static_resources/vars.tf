variable "ecr_repo_name" {
  type    = string
  default = "zookeeper-manager"
}

variable "s3_bucket_name" {
  type    = string
  default = "zookeeper-manager"
}

variable "backup_retention_days" {
  type  = string
  default = "1"
}