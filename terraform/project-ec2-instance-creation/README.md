# EC2 Instance Creation with Terraform

Basic Terraform project to create an AWS EC2 instance.

## Resources Created

- AWS EC2 Instance (t2.micro)
- Region: us-east-1
- AMI: Amazon Linux 2 (ami-0199fa5fada510433)
- Key Pair: terraform-practice1

## Prerequisites

- AWS CLI configured
- Terraform installed
- AWS credentials set up
- SSH key pair created in AWS

## Usage

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```
