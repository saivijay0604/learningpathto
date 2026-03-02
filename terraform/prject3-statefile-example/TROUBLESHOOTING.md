# Terraform State Lock Troubleshooting

## Common Lock Issues and Solutions

### 1. Local State Lock (terraform.tfstate)

**Error:**
```
Error: Error acquiring the state lock
Error message: resource temporarily unavailable
Path: terraform.tfstate
```

**Solutions:**

#### Check for stuck Terraform processes:
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

### 2. S3 Backend with DynamoDB Lock

**Error:**
```
Error: Error acquiring the state lock
Error message: ConditionalCheckFailedException
Path: bucket-name/path/terraform.tfstate
```

**Solutions:**

#### List all locks in DynamoDB:
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

### 3. Prevention Tips

- Always let Terraform commands complete fully
- Use `Ctrl+C` (not `Ctrl+Z`) to cancel operations
- Avoid running multiple Terraform commands simultaneously
- Use `-lock=false` only for read operations when necessary

### 4. Clean Slate

To completely reset Terraform initialization:
```bash
rm -rf .terraform .terraform.lock.hcl .terraform.tfstate.lock.info
terraform init
```
