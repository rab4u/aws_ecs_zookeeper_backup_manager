terraform {
  backend "s3" {
    key    = "zookeeper_backup_manager/terraform.tfstate"
    region = "eu-central-1"
  }
}