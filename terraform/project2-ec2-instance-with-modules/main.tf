# this file can be run from any where or any folder 

provider "aws"{
    region = "us-east-1"
}

module "ec2_instance_module" {
    source = "./main-code"
    ami_id = "ami-0199fa5fada510433"
    insatnce_value = "t2.micro"
   subnet_id = "subnet-01d48b61ce609e1dc"
  
}