# Variables Demo - A Complete Example! 💡

## What You'll Learn

This is a real example showing how to use variables to create a cloud computer (EC2 instance on AWS).

## The Complete Code

```hcl
# Define an input variable for the EC2 instance type
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

# Define an input variable for the EC2 instance AMI ID
variable "ami_id" {
  description = "EC2 AMI ID"
  type        = string
}

# Configure the AWS provider using the input variables
provider "aws" {
  region      = "us-east-1"
}

# Create an EC2 instance using the input variables
resource "aws_instance" "example_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
}

# Define an output variable to expose the public IP address of the EC2 instance
output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.example_instance.public_ip
}
```

## Breaking It Down Step-by-Step 👣

### Step 1: Input Variables (The Questions)

**Question 1:** What size computer do you want?
```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"  # If you don't answer, we'll use this small size
}
```

**Question 2:** Which computer image should we use?
```hcl
variable "ami_id" {
  description = "EC2 AMI ID"
  type        = string  # No default - you MUST provide this!
}
```

### Step 2: Provider Setup
```hcl
provider "aws" {
  region = "us-east-1"  # We're building in Virginia
}
```

### Step 3: Create the Computer
```hcl
resource "aws_instance" "example_instance" {
  ami           = var.ami_id         # Use the image you specified
  instance_type = var.instance_type  # Use the size you specified
}
```

### Step 4: Output (The Result)
```hcl
output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.example_instance.public_ip
}
```

After creating the computer, Terraform will show you its IP address (like a phone number for computers)!

## Why Use Variables Here? 🤔

**Without variables:**
- You'd have to edit the code every time you want a different size computer
- Hard to reuse for different projects

**With variables:**
- Change the size without touching the code!
- Reuse the same code for dev, test, and production
- Much easier to manage!

## Key Takeaway 🎯

This example shows the full cycle:
1. **Input** (ami_id, instance_type) → Information going in
2. **Process** (create the instance) → Terraform does the work
3. **Output** (public_ip) → Information coming out

It's like a recipe where you can change the ingredients (variables) but keep the same cooking instructions!