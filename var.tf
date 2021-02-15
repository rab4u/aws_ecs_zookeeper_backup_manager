# ECS CLUSTER NAME
variable "cluster_name" {
  type = string
}

# SERVER IPS - DEPENDS ON YOUR AWS SUBNETS
variable "server_ip_address_list" {
  type = list(string)
}

# EC2 INSTANCE DETAILS
variable "ec2_instance_type" {
  default = "t3.micro"
}

# EBS STORAGE DETAILS
variable "ebs" {
  type = object({
    volume_type = string
    volume_size = string
    delete_on_termination = string
  })
  default = {
    volume_type = "gp2"
    volume_size = "30"
    delete_on_termination = "true"
  }
}

# ECR REPO NAME
variable "ecr_repo_name" {
  type = string
}

# ECR IMAGE TAG
variable "ecr_image_tag" {
  type = string
  default = "latest"
}

# ENABLE OR DISABLE IMAGE PUSH TO ECR
variable "enable_image_push" {
  type = bool
  default = true
}

# ECS TASK DEFINITION TEMPLATE PATH
variable "ecs_task_def_template_file_path" {
  type    = string
  default = "./ecs_task_template/task_def.json"
}

# VPC DETAILS
variable "vpc_id" {
  type = string
}

# EC2 KEY PAIR
variable "ec2_key_pair_name" {
  type = string
}

# ENV
variable "env" {
  type = string
}

# AWS REGION
variable "aws_region" {
  type = string
}

# BACKUP TIME INTERVAL IN SECS
variable "backup_interval" {
  type = string
  default = "60"
}

# BACKUP PATH
variable "s3_backup_path" {
  type = string
}

# ZOOKEEPER SERVERS LIST (<<ZOO-SERVER-IP>>:<<PORT>>,<<ZOO-SERVER-IP>>:<<PORT>>,...)
variable "zookeeper_servers" {
  type = string
}