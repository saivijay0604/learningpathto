# Troubleshooting Guide

Common issues and solutions for the Terraform Provisioners project.

---

## 1. SSH Key Issues

### Error: `ssh: this private key is passphrase protected`

**Cause:** Your SSH private key has a passphrase, which Terraform provisioners don't support.

**Solution:**

Option A - Remove passphrase from existing key:
```bash
ssh-keygen -p -f ~/.ssh/id_rsa -N ""
```
Enter your old passphrase when prompted.

Option B - Generate new key without passphrase:
```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
```
Type `y` to overwrite if prompted.

---

## 2. Connection Timeout Issues

### Error: `dial tcp <IP>:22: i/o timeout`

**Cause:** Security group doesn't allow SSH access (port 22).

**Solution:**

Ensure your security group has SSH ingress rule:
```hcl
ingress {
    description = "SSH from VPC"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
```

Then run:
```bash
terraform apply
```

---

## 3. State Lock Issues

### Error: `Error acquiring the state lock`

**Cause:** Previous Terraform process crashed or was interrupted.

**Solution:**

Find and kill stuck processes:
```bash
ps aux | grep terraform
kill -9 <PID>
```

Remove lock file:
```bash
rm -f .terraform.tfstate.lock.info
```

---

## 4. Application Not Running

### Issue: Go app doesn't start automatically

**Cause:** Using `go run app.go &` doesn't persist after SSH disconnects.

**Solution:**

Update provisioner to use `nohup`:
```hcl
provisioner "remote-exec" {
    inline = [
        "sudo yum install -y golang",
        "cd /home/ec2-user",
        "nohup go run app.go > app.log 2>&1 &",
        "sleep 2"
    ]
}
```

**Manual fix on EC2:**
```bash
ssh -i ~/.ssh/id_rsa ec2-user@<IP>
nohup go run app.go > app.log 2>&1 &
```

---

## 5. Cannot Access Application

### Issue: Browser can't reach http://<IP>:8080

**Checks:**

1. Verify app is running:
```bash
ssh -i ~/.ssh/id_rsa ec2-user@<IP>
ps aux | grep "go run"
```

2. Check if port 8080 is listening:
```bash
netstat -tuln | grep 8080
```

3. Test locally on EC2:
```bash
curl localhost:8080
```

4. Verify security group allows port 8080:
```hcl
ingress {
    description = "Go App"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
```

5. Check application logs:
```bash
cat /home/ec2-user/app.log
```

---

## 6. Go Not Installed

### Error: `go: command not found`

**Cause:** Go installation failed during provisioning.

**Solution:**

SSH into instance and install manually:
```bash
ssh -i ~/.ssh/id_rsa ec2-user@<IP>
sudo yum install -y golang
go version
```

---

## 7. File Provisioner Fails

### Error: `Failed to upload file`

**Causes:**
- SSH connection issues
- Incorrect file path
- Permission issues

**Solutions:**

1. Verify source file exists:
```bash
ls -la app.go
```

2. Check SSH connection manually:
```bash
ssh -i ~/.ssh/id_rsa ec2-user@<IP>
```

3. Ensure destination directory exists and is writable

---

## 8. AWS Credentials Issues

### Error: `No valid credential sources found`

**Solution:**

Configure AWS credentials:
```bash
aws configure
```

Or set environment variables:
```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

---

## 9. Resource Already Exists

### Error: `resource already exists`

**Cause:** Resources from previous run weren't cleaned up.

**Solution:**

Option A - Import existing resources:
```bash
terraform import aws_key_pair.keypair terraform-demo-vijay
```

Option B - Destroy and recreate:
```bash
terraform destroy
terraform apply
```

Option C - Change resource names in main.tf

---

## 10. Instance Not Getting Public IP

### Issue: EC2 instance has no public IP

**Cause:** Subnet not configured for auto-assign public IP.

**Solution:**

Ensure subnet has:
```hcl
resource "aws_subnet" "subnet1" {
    map_public_ip_on_launch = true
    # ... other config
}
```

---

## Debugging Tips

### Enable Terraform Debug Logging
```bash
export TF_LOG=DEBUG
terraform apply
```

### Check Terraform State
```bash
terraform show
terraform state list
```

### Validate Configuration
```bash
terraform validate
terraform fmt
```

### SSH Debug Mode
```bash
ssh -vvv -i ~/.ssh/id_rsa ec2-user@<IP>
```

### Check EC2 System Logs
In AWS Console: EC2 → Instances → Actions → Monitor and troubleshoot → Get system log

---

## Getting Help

If issues persist:
1. Check Terraform documentation: https://www.terraform.io/docs
2. Review AWS EC2 documentation
3. Check security group rules in AWS Console
4. Verify VPC and subnet configuration
5. Review CloudWatch logs for the instance
