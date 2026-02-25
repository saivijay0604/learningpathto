# EC2 Instance Creation with Terraform

## AWS Configuration Steps

1. **Check AWS Identity**
   ```bash
   aws sts get-caller-identity
   ```

2. **Verify AWS Configuration**
   ```bash
   aws configure list
   ```
   - Region: `us-east-1`
   - Credentials: Configured in `~/.aws/credentials`

## Steps Completed

1. **Configured AWS CLI**
   - Region: `us-east-1`

2. **Fixed AMI ID**
   - Original AMI didn't exist in us-east-1
   - Updated to valid Amazon Linux 2 AMI: `ami-0199fa5fada510433`

3. **Fixed Subnet ID**
   - Original subnet didn't exist
   - Updated to valid subnet: `subnet-01d48b61ce609e1dc` (us-east-1b)

4. **Created Key Pair**
   - Created key pair: `terraform-practice1`
   - Private key saved as: `terraform-practice1.pem`
   - Permissions set to 400

## Terraform Configuration

- **Provider**: AWS (us-east-1)
- **Resource**: EC2 Instance
- **AMI**: ami-0199fa5fada510433 (Amazon Linux 2)
- **Instance Type**: t2.micro
- **Subnet**: subnet-01d48b61ce609e1dc
- **Key Pair**: terraform-practice1

## Terraform Workflow

### 1. terraform init
```bash
terraform init
```
**Description:**
- Initializes the Terraform working directory
- Downloads and installs the AWS provider plugin
- Creates `.terraform` directory to store provider binaries
- Initializes the backend for state storage
- Creates `.terraform.lock.hcl` file to lock provider versions
- Must be run before any other Terraform commands

### 2. terraform plan
```bash
terraform plan
```
**Description:**
- Creates an execution plan showing what Terraform will do
- Compares current state with desired configuration
- Shows resources to be created (+), modified (~), or destroyed (-)
- Does NOT make any actual changes to infrastructure
- Helps review changes before applying them
- Validates configuration syntax and logic

### 3. terraform apply
```bash
terraform apply
```
**Description:**
- Executes the planned changes to create/modify infrastructure
- Shows the execution plan and prompts for confirmation (type `yes`)
- Creates the EC2 instance in AWS
- Updates the `terraform.tfstate` file with current infrastructure state
- Displays outputs and resource details after completion
- Use `terraform apply -auto-approve` to skip confirmation prompt

### 4. terraform show (Optional)
```bash
terraform show
```
**Description:**
- Displays the current state of infrastructure
- Shows all resource attributes and values
- Useful for inspecting what was created

### 5. terraform destroy (Cleanup)
```bash
terraform destroy
```
**Description:**
- Destroys all resources managed by Terraform
- Prompts for confirmation before deletion
- Removes the EC2 instance and cleans up infrastructure
- Updates state file to reflect destroyed resources
