terraform {
  backend "s3" {
    key    = "static-resources/terraform.tfstate"
    region = "eu-central-1"
  }
}