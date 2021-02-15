# ZOOKEEPER MANAGER 
#### Contents:
1. Intro
2. Prerequisites 
3. Setup
4. How to access Zookeeper Manager endpoints (UI and metrics ports)   
5. How to Restore the backup   
6. Troubleshooting

## 1. Intro
Zookeeper Manager provides 
1. Backup of Z-Nodes
2. Restore of Z-Nodes from backup
3. UI to manage Z-Nodes and ACLs (ZooNavigator - https://zoonavigator.elkozmon.com/en/1.1.0/)

This repo holds all the necessary code to deploy Zookeeper Manager on AWS ECS. 

## 2. Prerequisites
1. AWS Account 
2. AWS Credentials or Profile (Preferably power user) 
3. AWS VPC with NAT/Internet gateway to reach internet (This is required for ECS Cluster to communicate with the ECS services and to pull docker images from public Docker Hub. https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Scenario2.htm)
4. Terraform >= 0.14
5. AWS S3 Bucket to store terraform state remotely
6. EC2 key pair (later used to SSH into the ec2 instances for troubleshooting)

## 3. Setup
1. Clone this repo
```
https://github.com/rab4u/aws_ecs_zookeeper_manager
```
2. Export AWS credentials

If AWS Profile is used (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)
```
export AWS_PROFILE=<<profile name>>
export AWS_SDK_LOAD_CONFIG=1
```
If AWS Credentials are used
```
export AWS_ACCESS_KEY_ID="<<Access key id>>"
export AWS_SECRET_ACCESS_KEY="<<Secret Access key>>"
# IF SESSION TOKEN IS PRESENT
export AWS_SESSION_TOKEN="<<Session Token>>"
```
3. Export Terraform init parameters
```
export bucket="<<AWS S3 bucket name>>"
export TF_CLI_ARGS_init="-backend-config=\"bucket=${bucket}\""
```
4. Create the static resources like s3 bucket for backup and AWS ECR repo to hold Zookeeper Manager image
```
cd static_resources
terraform init
terraform plan
terraform apply
cd ..
```   
5. Once, after creating the static resources. Update the var-dev.tfvars or var-prod.tfvars depending on your environment

| Parameter              	| Type         	| Default Value                                      	| Description                                                                                                                                                                                                       	|
|------------------------	|--------------	|----------------------------------------------------	|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	|
| cluster_name           	| string       	| zookeeper-manager                                   	| ZOOKEEPER MANAGER CLUSTER NAME                                                                                                                                                                                       	|
| ecr_repo_name           	| string       	| zookeeper-manager                                    	| ZOOKEEPER OFFICIAL IMAGE                                                                                                                                                                                          	|
| ec2_instance_type      	| string       	| t2.micro                                           	| EC2 INSTANCE TYPE                                                                                                                                                                                                 	|
| server_ip_address_list 	| list(string) 	| [ "11.11.1.15" ]   	                                | ZOOKEEPER MANAGER IPS - DEPENDS ON YOUR AWS SUBNETS                                                                                                                                                                 	|
| ec2_key_pair_name      	| string       	| zookeeper_ec2_key_pair                             	| EC2 KEY PAIR                                                                                                                                                                                                      	|
| env                    	| string       	| dev                                                	| ENVIRONMENT                                                                                                                                                                                                       	|
| aws_region             	| string       	| eu-central-1                                       	| AWS REGION                                                                                                                                                                                                        	|
| vpc_id                 	| string       	| ""                                                 	| VPC ID. please provide VPC ID                                                                                                                                                                                     	|
| ecr_image_tag            	| string       	| latest                                               	| ECR IMAGE TAG                                                                                                                                                                                    	                    |
| enable_image_push        	| bool       	| true                                               	| ENABLE OR DISABLE IMAGE PUSH TO ECR                                                                                                                                                                                   |
| s3_backup_path           	| string       	| zookeeper-manager                             	| S3 PATH FOR BACKUP WITHOUT S3://                                                                                                                                                                                         	|
| zookeeper_servers         | string       	| ""                                                 	| ZOOKEEPER SERVERS.Format : <<ZOO-SERVER-IP>>:<<PORT>>,<<ZOO-SERVER-IP>>:<<PORT>>,...                                                                                                                                  |

5. Initialize terraform
```
terraform init
```
6. Check the terraform plan (around 28 resources will be created)
```
terraform plan
```
7. terraform apply
```
terraform apply --var-file=vars-dev.tfvars 
```

Hurrah !! In a few minutes Zookeeper Manager will be up and running. Check the S3 path for Zookeeper backup data.

## 4. How to access Zookeeper Manager endpoints (UI and metrics ports)
 - By default, The security group allows the VPC CIDR block so, any instance or service deployed in the same VPC can reach Zookeeper Manager endpoints.
 - To customize as per your needs please, modify the terraform file ```ecs-security-group.tf```
 - Zookeeper Manager endpoint URL format for UI : ```<<IP ADDRESS>>:9000```
 - Zookeeper Manager endpoint URL format for metrics: ```<<IP ADDRESS>>:5000/metrics```

Note : For public access, deploy the ecs cluster in public subnet with auto assign public ip enabled in the subnet.

## 5. How to Restore the backup
Note: Restoring backup should be done with caution. 

Step 1: SSH to the Zookeeper Manager
```
sudo ssh -i <<ssh key / pem file>> ec2-user@<<Zookeeper manager IP>>
```
Step 3: Run the below docker command
```
sudo docker ps 
# Get the backup time from the s3 bucket (created above in the step 4) where the backup snapshots are stored
sudo docker exec -it <<zookeeper backup manager container id>> ./aws_s3_restore_service.sh
```
Follow the instructions of the script


## 6. Troubleshooting 
##### No EC2 instances are attached to the ECS cluster : 
Probably, ECS cluster is not able to communicate with ECS services of AWS. 
1. Check whether the instances are able to reach the internet (This is required to communicate with AWS ECS services)
2. If private subnet IP addresses are used while launching ECS cluster please, make sure there is a
public subnet with NAT gateway and proper route - follow the instructions in this link - https://zookeeper.apache.org/doc/r3.5.3-beta/zookeeperReconfig.html

##### Invalid index. count.index is n, var.network_details is list of object with n elements
One or more IP addresses are doesn't belong to any subnet in the VPC ID provided. 
1. please make sure VPC ID is correct
2. check the IP addresses are in the range of VPC subnets

##### Error: Error running command 'terraform_modules/ecr_module/push.sh './docker' '273165895809.dkr.ecr.eu-central-1.amazonaws.com/zookeeper-backup-manager' latest': exit status 1
#### OR
##### module.ecs-ecr.null_resource.push[0] (local-exec): Got permission denied while trying to connect to the Docker daemon socket at unix
Docker permission denied. please follow the instructions in the link for adding user to the docker group - https://docs.docker.com/engine/install/linux-postinstall/