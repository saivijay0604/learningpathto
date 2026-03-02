variable "ami_id" {
    description = "This is the place to provide the ami id" 
}

variable "instance_value" {
    description = "This is the place to provide the instance type"
    default = "t2.micr0"
    
}

variable "subnet_value"{
    description = "This is the place to provide the subnet id"
}

variable "keypair_name" {
  description = "enter the key name"
}

variable "bucket_name"{
    description = "S3 bucket Name for backup file"
}



