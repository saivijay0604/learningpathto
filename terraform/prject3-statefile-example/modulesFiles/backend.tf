terraform {
  backend "s3" {
    bucket = "terraform-statefile-bucket-vijay-2024"
    region = "us-east-1"
    key =  "vijay/terraform.tfstate"
    dynamodb_table = "terraform-lock"
    encrypt = true
  }
}
