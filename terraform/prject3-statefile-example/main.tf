provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "first-instance"{
    ami = var.ami_id
    instance_type = var.instance_value
    subnet_id = var.subnet_value
    key_name = var.keypair_name
}


resource "aws_s3_bucket" "s3bucket_statefile"{
    bucket = var.bucket_name
}

resource "aws_dynamodb_table" "dynamoDB_for_statefile" {
    name           = "terraform-lock"
    billing_mode   = "PAY_PER_REQUEST"
    hash_key       = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
  
}
  
