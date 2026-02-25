provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "first-instance"{
    ami = "ami-0199fa5fada510433"
    instance_type = "t2.micro"
    subnet_id = "subnet-01d48b61ce609e1dc"
    key_name = "terraform-practice1"
}