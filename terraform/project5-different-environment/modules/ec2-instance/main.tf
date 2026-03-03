# AWS Provider Configuration for the Module
# This provider block is inherited from the root module
provider "aws" {
    region = "us-east-1"
}

# Input Variable: AMI ID
# Receives the Amazon Machine Image ID from the parent module
variable "ami_id" {
    description = "This is for ami id"
}

# Input Variable: Instance Type
# Receives the EC2 instance type (t2.micro, t2.small, t2.large)
# Value is determined by the workspace in the parent module
variable "insatnce_value" {
    description = "This is for instance type"
}

# Input Variable: Subnet ID
# Receives the VPC subnet ID where the instance will be deployed
variable "subnet_value"{
    description = "This where we can find the subnet id"
}

# Resource: EC2 Instance
# Creates an AWS EC2 instance with the provided configuration
# This is a reusable module that can be called from any environment
resource "aws_instance" "example" {
    ami           = var.ami_id           # Operating system image
    instance_type = var.insatnce_value   # Size of the instance (CPU, RAM)
    subnet_id     = var.subnet_value     # Network location
}