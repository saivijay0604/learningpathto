# Setting Up Remote State with S3 🪣

## Overview

This guide shows how to configure Terraform to store state files remotely in AWS S3 with DynamoDB locking.

## Prerequisites

- AWS Account
- AWS CLI configured
- Terraform installed

## Step 1: Create S3 Bucket for State Storage

### Option A: Using Terraform

```hcl
resource "aws_s3_bucket" "terraform_state" {
    bucket = "terraform-statefile-bucket-vijay-2024"
}
```

### Option B: Using AWS CLI

```bash
aws s3 mb s3://terraform-statefile-bucket-vijay-2024 --region us-east-1
```

## Step 2: Create DynamoDB Table for State Locking

### Using Terraform

```hcl
resource "aws_dynamodb_table" "terraform_locks" {
    name           = "terraform-lock"
    billing_mode   = "PAY_PER_REQUEST"
    hash_key       = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}
```

### Using AWS CLI

```bash
aws dynamodb create-table \
  --table-name terraform-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

## Step 3: Configure Backend

Create `backend.tf`:

```hcl
terraform {
  backend "s3" {
    bucket         = "terraform-statefile-bucket-vijay-2024"
    key            = "vijay/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
```

## Step 4: Initialize and Migrate State

### First Time Setup

```bash
terraform init
```

### Migrate Existing Local State to S3

```bash
terraform init -migrate-state
```

Terraform will prompt:
```
Do you want to copy existing state to the new backend?
  Enter a value: yes
```

## Step 5: Verify Setup

Check that state file is in S3:

```bash
aws s3 ls s3://terraform-statefile-bucket-vijay-2024/vijay/
```

## Project Structure

```
prject3-statefile-example/
├── main.tf              # Resources (EC2, S3, DynamoDB)
├── variables.tf         # Variable definitions
├── terraform.tfvars     # Variable values
├── backend.tf           # Backend configuration (if using modules)
├── backupfile.tf        # Commented backend config
└── modulesFiles/
    ├── main.tf          # Module usage
    └── backend.tf       # Backend for module directory
```

## Important Notes

### Backend Configuration Location

- Backend must be in the **root module** where you run `terraform` commands
- If running from `modulesFiles/`, put `backend.tf` there
- If running from project root, put `backend.tf` there

### State Locking

- DynamoDB automatically locks state during operations
- Prevents concurrent modifications
- Lock is released when operation completes

### Security Best Practices

```hcl
terraform {
  backend "s3" {
    bucket         = "your-bucket-name"
    key            = "path/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true              # ✅ Always encrypt
    dynamodb_table = "terraform-lock"  # ✅ Always use locking
  }
}
```

## Common Commands

### Initialize backend
```bash
terraform init
```

### Migrate state to new backend
```bash
terraform init -migrate-state
```

### Reconfigure backend
```bash
terraform init -reconfigure
```

### Force unlock (if stuck)
```bash
terraform force-unlock <LOCK_ID>
```

## Benefits

✅ **Team Collaboration** - Multiple people can work on same infrastructure
✅ **State Backup** - Automatic versioning in S3
✅ **State Locking** - Prevents conflicts with DynamoDB
✅ **Security** - Encrypted state storage
✅ **Disaster Recovery** - State survives local machine failures

## Troubleshooting

See [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) for lock issues and solutions.
