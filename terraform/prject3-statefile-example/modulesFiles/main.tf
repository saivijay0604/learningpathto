provider "aws" {
    region =   "us-east-1"
  
}

module "ec2_instance_module" {
    source = "../"
    ami_id = "ami-0199fa5fada510433"
    instance_value = "t2.micro"
    subnet_value = "subnet-01d48b61ce609e1dc"
    keypair_name = "terraform-practice1"
    bucket_name = "terraform-statefile-bucket-vijay-2024"
}