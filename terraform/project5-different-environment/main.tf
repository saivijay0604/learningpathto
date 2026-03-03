# AWS Provider Configuration
# Specifies the AWS region where resources will be created
provider "aws" {
    region = "us-east-1"
}

# Variable: AMI ID
# The Amazon Machine Image ID to use for the EC2 instance
# Value is provided in terraform.tfvars file
variable "ami_id" {
    description = "This is for ami id"
}

# Variable: Instance Type Map
# Maps each environment (workspace) to a specific EC2 instance type
# This allows different instance sizes for dev, staging, and production
variable "insatnce_value" {
    description = "insatnce value"
    type = map(string)
    
    default = {
        dev = "t2.micro"        # Small instance for development
        staging = "t2.small"     # Medium instance for staging
        production = "t2.large"  # Large instance for production
    }
}

# Variable: Subnet ID
# The VPC subnet where the EC2 instance will be launched
# Value is provided in terraform.tfvars file
variable "subnet_value" {
    description = "value"
}

# Module: EC2 Instance
# Creates an EC2 instance using the reusable module
# The instance type is dynamically selected based on the current workspace
module "ec2_instance_module" {
    source = "./modules/ec2-instance"
    ami_id = var.ami_id
    
    # lookup() function: Retrieves the instance type based on current workspace
    # Syntax: lookup(map, key, default)
    # - map: var.insatnce_value (contains dev/staging/production mappings)
    # - key: terraform.workspace (current workspace name)
    # - default: "t2.micro" (fallback if workspace not found in map)
    insatnce_value = lookup(var.insatnce_value, terraform.workspace, "t2.micro")
    
    subnet_value = var.subnet_value
}