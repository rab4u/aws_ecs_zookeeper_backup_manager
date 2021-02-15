# ECS CLUSTER NAME
cluster_name = "aws-ecs-zookeeper-manager"

# EC2 INSTANCE TYPE
ec2_instance_type = "t2.micro"

# SERVER IPS - DEPENDS ON YOUR AWS SUBNETS
server_ip_address_list = [
  "11.11.1.15"
]

# EC2 KEY PAIR
ec2_key_pair_name = "zookeeper_ec2_key_pair"

# ENV
env = "dev"

# AWS REGION
aws_region = "eu-central-1"

# VPC DETAILS
vpc_id = "vpc-0f6b47bc99dadac8d"

# ECR REPO NAME
ecr_repo_name = "zookeeper-backup-manager"

# ECR IMAGE TAG
ecr_image_tag = "latest"

# ENABLE OR DISABLE IMAGE PUSH TO ECR
enable_image_push = true

# S3 PATH FOR BACKUP WITHOUT S3://
s3_backup_path = "zookeeper-backup-manager"

# ZOOKEEPER SERVERS
zookeeper_servers = "11.11.1.11:2181,11.11.2.12:2181,11.11.3.13:2181"