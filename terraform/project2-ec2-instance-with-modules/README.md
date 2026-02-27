# Project 2 - EC2 Instance with Modules 🚀

## What This Project Does

This project creates an EC2 instance (a virtual computer in AWS) using Terraform modules. It's like building with LEGO blocks - we organize our code into reusable pieces!

## Project Structure 📁

```
project2-ec2-instance-with-modules/
├── main.tf                    # Main file that uses the module
└── main-code/                 # The module folder
    ├── main.tf                # Creates the EC2 instance
    ├── variables.tf           # Input variables (questions)
    ├── output.tf              # Output values (results)
    └── terraform.tfvars       # Variable values (answers)
```

## How It Works 🔧

### Step 1: The Module (main-code folder)

This is our reusable LEGO block! It contains:

**variables.tf** - The questions we need answered:
- What AMI ID? (Which computer image?)
- What instance type? (What size computer?)
- What subnet ID? (Which network?)

**main.tf** - Creates the actual EC2 instance using those variables

**output.tf** - Shows the public IP address after creation

**terraform.tfvars** - Provides the actual values:
```hcl
ami_id = "ami-0199fa5fada510433"
insatnce_value = "t2.micro"
subnet_id = "subnet-01d48b61ce609e1dc"
```

### Step 2: Using the Module (main.tf in root)

```hcl
provider "aws"{
    region = "us-east-1"
}

module "ec2_instance_module" {
    source = "./main-code"
    ami_id = "ami-0199fa5fada510433"
    insatnce_value = "t2.micro"
    subnet_id = "subnet-01d48b61ce609e1dc"
}
```

**What's happening:**
1. Set up AWS provider for us-east-1 region
2. Call the module from `./main-code` folder
3. Pass in the required values

## Why Use Modules Here? 🤔

### Without Modules:
- All code in one file
- Hard to reuse
- Messy and confusing

### With Modules:
- ✅ Organized code
- ✅ Can reuse the module for multiple EC2 instances
- ✅ Easy to understand
- ✅ Easy to maintain

## What Gets Created ☁️

When you run this project, Terraform creates:
- 1 EC2 instance (t2.micro - small size)
- In us-east-1 region (Virginia)
- In the specified subnet
- Returns the public IP address

## How to Run 🏃

```bash
# Initialize Terraform
terraform init

# See what will be created
terraform plan

# Create the resources
terraform apply

# Destroy when done
terraform destroy
```

## Key Takeaway 🎯

This project shows how to:
- Create a reusable module
- Use variables to make it flexible
- Call the module from a main file
- Get outputs (public IP address)

**Think of it like:** A recipe (module) that you can use multiple times with different ingredients (variables)!
