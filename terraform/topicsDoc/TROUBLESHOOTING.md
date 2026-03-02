# Terraform Troubleshooting Guide 🔧

## State Lock Issues

### Problem 1: Local State Lock Error

**Error:**
```
Error: Error acquiring the state lock
Error message: resource temporarily unavailable
Path: terraform.tfstate
```

**Cause:** A Terraform process is stuck or was interrupted.

**Solutions:**

#### Check for stuck processes:
```bash
ps aux | grep terraform | grep -v grep
```

#### Kill stuck processes:
```bash
kill -9 <PID>
```

#### Remove local lock file:
```bash
rm -f .terraform.tfstate.lock.info
```

---

### Problem 2: S3 Backend Lock Error

**Error:**
```
Error: Error acquiring the state lock
Error message: ConditionalCheckFailedException
Path: bucket-name/path/terraform.tfstate
```

**Cause:** DynamoDB lock table has a stale lock entry.

**Solutions:**

#### List all locks:
```bash
aws dynamodb scan --table-name terraform-lock --region us-east-1
```

#### Delete specific lock:
```bash
aws dynamodb delete-item \
  --table-name terraform-lock \
  --key '{"LockID":{"S":"bucket-name/path/terraform.tfstate"}}' \
  --region us-east-1
```

#### Delete all locks (use with caution):
```bash
aws dynamodb scan --table-name terraform-lock --region us-east-1 | \
  jq -r '.Items[].LockID.S' | \
  xargs -I {} aws dynamodb delete-item \
    --table-name terraform-lock \
    --key '{"LockID":{"S":"{}"}}' \
    --region us-east-1
```

---

### Problem 3: DynamoDB Table Not Found

**Error:**
```
Error: ResourceNotFoundException: Requested resource not found
```

**Cause:** DynamoDB table was deleted but backend still references it.

**Solutions:**

#### Option 1: Recreate the table
```bash
aws dynamodb create-table \
  --table-name terraform-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

#### Option 2: Disable locking temporarily
```bash
terraform plan -lock=false
terraform apply -lock=false
terraform destroy -lock=false
```

---

## S3 Bucket Issues

### Problem 4: Bucket Not Empty

**Error:**
```
Error: deleting S3 Bucket: BucketNotEmpty
```

**Cause:** S3 bucket contains files (usually the state file).

**Solutions:**

#### Empty the bucket:
```bash
aws s3 rm s3://bucket-name --recursive
```

#### Or add force_destroy to resource:
```hcl
resource "aws_s3_bucket" "terraform_state" {
    bucket        = "my-bucket"
    force_destroy = true
}
```

---

### Problem 5: Bucket Already Exists

**Error:**
```
Error: creating S3 Bucket: BucketAlreadyExists
```

**Cause:** Bucket name is globally taken or already exists in your account.

**Solutions:**

#### Import existing bucket:
```bash
terraform import aws_s3_bucket.terraform_state bucket-name
```

#### Or use a unique name:
```hcl
bucket = "terraform-state-${var.project}-${random_id.bucket_suffix.hex}"
```

---

## Module Issues

### Problem 6: Module Not Installed

**Error:**
```
Error: Module not installed
This module is not yet installed. Run "terraform init"
```

**Solution:**
```bash
terraform init
```

---

### Problem 7: Module Source Path Wrong

**Error:**
```
Error: Unreadable module directory
```

**Cause:** Incorrect module source path.

**Solution:**

If calling from subdirectory, use relative path:
```hcl
module "example" {
  source = "../"  # Parent directory
}
```

---

## Resource Issues

### Problem 8: Resource Already Exists

**Error:**
```
Error: resource already exists
```

**Solution:**

Import the existing resource:
```bash
terraform import aws_instance.example i-1234567890abcdef0
terraform import aws_s3_bucket.example bucket-name
terraform import aws_dynamodb_table.example table-name
```

---

### Problem 9: Orphaned Resources

**Problem:** Resources exist in AWS but not in Terraform state.

**Solution:**

#### Terminate manually:
```bash
# EC2 instance
aws ec2 terminate-instances --instance-ids i-xxxxx --region us-east-1

# S3 bucket
aws s3 rb s3://bucket-name --force

# DynamoDB table
aws dynamodb delete-table --table-name table-name --region us-east-1
```

---

## Initialization Issues

### Problem 10: Backend Configuration Ignored

**Warning:**
```
Warning: Backend configuration ignored
```

**Cause:** Backend defined in a module instead of root.

**Solution:**

Move backend configuration to the root module where you run `terraform` commands:
```hcl
# In root main.tf or backend.tf
terraform {
  backend "s3" {
    bucket = "my-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
```

---

## Prevention Tips 🛡️

1. **Always let Terraform complete** - Don't interrupt with Ctrl+Z
2. **Use Ctrl+C to cancel** - Not Ctrl+Z (which suspends the process)
3. **Enable state locking** - Always use DynamoDB with S3 backend
4. **Backup state files** - Enable S3 versioning
5. **Use workspaces** - For multiple environments
6. **Test in dev first** - Before applying to production

---

## Emergency Commands 🚨

### Force unlock state:
```bash
terraform force-unlock <LOCK_ID>
```

### Refresh state:
```bash
terraform refresh
```

### Show current state:
```bash
terraform show
```

### List resources in state:
```bash
terraform state list
```

### Remove resource from state (doesn't delete actual resource):
```bash
terraform state rm aws_instance.example
```

### Clean slate:
```bash
rm -rf .terraform .terraform.lock.hcl .terraform.tfstate.lock.info
terraform init
```

---

## Common Workflow Issues

### Stuck Process Detection:
```bash
# Find all terraform processes
ps aux | grep terraform

# Status "T" means stopped/suspended - these need to be killed
# Status "S" means sleeping - usually OK
# Status "R" means running - usually OK
```

### Check AWS Resources:
```bash
# List EC2 instances
aws ec2 describe-instances --region us-east-1

# List S3 buckets
aws s3 ls

# List DynamoDB tables
aws dynamodb list-tables --region us-east-1
```

---

## Best Practices ✅

1. **Version control** - Commit `.tf` files, NOT state files
2. **Remote backend** - Always use S3 + DynamoDB for teams
3. **State locking** - Never disable unless absolutely necessary
4. **Encryption** - Enable for S3 backend
5. **Separate environments** - Use workspaces or separate state files
6. **Regular backups** - Enable S3 versioning
7. **Access control** - Use IAM policies for state bucket
8. **Plan before apply** - Always review changes first

---

## Quick Reference

| Issue | Command |
|-------|---------|
| Kill stuck process | `kill -9 <PID>` |
| Remove local lock | `rm -f .terraform.tfstate.lock.info` |
| Clear DynamoDB lock | `aws dynamodb delete-item --table-name terraform-lock --key '{"LockID":{"S":"..."}}' --region us-east-1` |
| Empty S3 bucket | `aws s3 rm s3://bucket-name --recursive` |
| Import resource | `terraform import <resource_type>.<name> <id>` |
| Force unlock | `terraform force-unlock <LOCK_ID>` |
| Disable locking | `terraform apply -lock=false` |
| Clean init | `rm -rf .terraform && terraform init` |
