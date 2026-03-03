# Terraform Provisioners Example - Deploy Go App on AWS EC2

This project demonstrates how to use Terraform provisioners to deploy a Go web application on an AWS EC2 instance.

## Prerequisites

- Terraform installed (v1.0+)
- AWS CLI configured with credentials
- SSH key pair generated

## Project Structure

```
project4-provisioners-example/
├── main.tf           # Terraform configuration
├── app.go            # Go web application
├── README.md         # This file
└── TROUBLESHOOTING.md # Common issues and solutions
```

## Steps to Run

### 1. Generate SSH Key Pair

```bash
mkdir -p ~/.ssh
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
```

**Note:** Leave passphrase empty (press Enter twice) as Terraform provisioners don't support passphrase-protected keys.

### 2. Initialize Terraform

```bash
cd terraform/project4-provisioners-example
terraform init
```

This downloads the AWS provider plugin.

### 3. Review the Plan

```bash
terraform plan
```

This shows what resources will be created.

### 4. Apply the Configuration

```bash
terraform apply
```

Type `yes` when prompted. This will:
- Create a VPC with public subnet
- Set up Internet Gateway and routing
- Create security groups (ports 22, 80, 8080)
- Launch EC2 instance
- Copy app.go to the instance
- Install Go and run the application

### 5. Get the Public IP

After successful apply, note the EC2 instance's public IP from the output or AWS console.

### 6. Access the Application

Open your browser and navigate to:
```
http://<EC2_PUBLIC_IP>:8080
```

You should see: `Hello, Terraform!`

### 7. SSH into the Instance (Optional)

```bash
ssh -i ~/.ssh/id_rsa ec2-user@<EC2_PUBLIC_IP>
```

### 8. Clean Up Resources

```bash
terraform destroy
```

Type `yes` to remove all created resources.

## What Gets Created

1. **VPC** - Virtual Private Cloud (10.0.0.0/16)
2. **Subnet** - Public subnet (10.0.1.0/24) in us-east-1a
3. **Internet Gateway** - For internet access
4. **Route Table** - Routes traffic to internet
5. **Security Group** - Firewall rules for SSH, HTTP, and port 8080
6. **Key Pair** - SSH key for EC2 access
7. **EC2 Instance** - t2.micro Amazon Linux 2 instance
8. **Go Application** - Web server running on port 8080

## Application Details

The Go application (`app.go`) is a simple HTTP server that:
- Listens on port 8080
- Responds with "Hello, Terraform!" on the root path (/)

## Provisioners Used

1. **file provisioner** - Copies app.go from local machine to EC2
2. **remote-exec provisioner** - Executes commands on EC2:
   - Installs Go
   - Runs the application in background using nohup

## Security Notes

⚠️ **Warning:** This configuration allows access from anywhere (0.0.0.0/0). For production:
- Restrict SSH access to your IP only
- Use a bastion host
- Enable AWS Systems Manager Session Manager
- Use secrets manager for sensitive data

## Cost Estimate

- t2.micro instance: Free tier eligible (750 hours/month)
- Other resources: Minimal to no cost in free tier
- Remember to run `terraform destroy` when done!
