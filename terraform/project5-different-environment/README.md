# Project 5: Managing Different Environments with Terraform Workspaces

## 📋 Project Overview

This project demonstrates how to manage multiple environments (dev, staging, production) using **Terraform Workspaces**. Instead of duplicating code for each environment, workspaces allow you to use the same configuration with environment-specific values.

## 🎯 What This Project Does

- Creates EC2 instances with different instance types based on the workspace (environment)
- Uses a modular approach with reusable EC2 module
- Leverages `lookup()` function to select environment-specific instance types
- Manages separate state files for each environment using workspaces

## 🏗️ Project Structure

```
project5-different-environment/
├── main.tf                    # Root configuration with workspace logic
├── terraform.tfvars           # Variable values (AMI ID, Subnet ID)
├── modules/
│   └── ec2-instance/
│       └── main.tf            # Reusable EC2 module
└── terraform.tfstate.d/       # Workspace-specific state files
    ├── dev/
    ├── stage/
    └── prod/
```

## 🔧 Terraform Workspace Commands

### Getting Help
```bash
terraform workspace -h
```
**Output:**
```
Usage: terraform [global options] workspace

  new, list, show, select and delete Terraform workspaces.

Subcommands:
    delete    Delete a workspace
    list      List Workspaces
    new       Create a new workspace
    select    Select a workspace
    show      Show the name of the current workspace
```

The `terraform workspace` command provides 5 subcommands to manage workspaces:
- **new** - Creates a new workspace
- **list** - Lists all available workspaces
- **show** - Displays the current workspace name
- **select** - Switches to a different workspace
- **delete** - Removes a workspace

### 1. List All Workspaces
```bash
terraform workspace list
```
Shows all available workspaces. The current workspace is marked with `*`

### 2. Create a New Workspace
```bash
terraform workspace new dev
terraform workspace new staging
terraform workspace new production
```
Creates a new workspace and automatically switches to it.

### 3. Select/Switch Workspace
```bash
terraform workspace select dev
terraform workspace select staging
terraform workspace select production
```
Switches to an existing workspace.

### 4. Show Current Workspace
```bash
terraform workspace show
```
Displays the name of the current workspace.

### 5. Delete a Workspace
```bash
terraform workspace delete dev
```
Deletes a workspace (cannot delete the current workspace or default).

## 📝 Step-by-Step Implementation

### Step 1: Initialize Terraform
```bash
terraform init
```
Downloads providers and initializes the working directory.

### Step 2: Create Development Workspace
```bash
terraform workspace new dev
```
Creates and switches to the `dev` workspace.

### Step 3: Plan for Development
```bash
terraform plan
```
Shows what will be created in the dev environment (t2.micro instance).

### Step 4: Apply Development Configuration
```bash
terraform apply
```
Creates the EC2 instance in the dev environment.

### Step 5: Create Staging Workspace
```bash
terraform workspace new staging
```
Creates and switches to the `staging` workspace.

### Step 6: Apply Staging Configuration
```bash
terraform apply
```
Creates a t2.small instance for staging environment.

### Step 7: Create Production Workspace
```bash
terraform workspace new production
```
Creates and switches to the `production` workspace.

### Step 8: Apply Production Configuration
```bash
terraform apply
```
Creates a t2.large instance for production environment.

### Step 9: Switch Between Environments
```bash
# View dev resources
terraform workspace select dev
terraform show

# View staging resources
terraform workspace select staging
terraform show

# View production resources
terraform workspace select production
terraform show
```

### Step 10: Cleanup
```bash
# Destroy resources in current workspace
terraform destroy

# Switch and destroy other workspaces
terraform workspace select dev
terraform destroy

terraform workspace select staging
terraform destroy
```

## 🔑 Key Concepts Used

### 1. **Terraform Workspaces**
- Allows managing multiple environments with the same configuration
- Each workspace has its own state file
- Access current workspace name using `terraform.workspace`

### 2. **lookup() Function**
```hcl
lookup(var.insatnce_value, terraform.workspace, "t2.micro")
```
- Searches for a key in a map
- Returns the value if found, otherwise returns the default value
- Syntax: `lookup(map, key, default)`

### 3. **Modules**
- Reusable components that encapsulate resources
- Promotes DRY (Don't Repeat Yourself) principle
- Makes code maintainable and scalable

## 🌍 Environment Configuration

| Workspace   | Instance Type | Use Case          |
|-------------|---------------|-------------------|
| dev         | t2.micro      | Development/Testing|
| staging     | t2.small      | Pre-production    |
| production  | t2.large      | Production workload|

## 📊 How It Works

1. **Variable Definition**: Instance types are defined in a map for each environment
2. **Workspace Selection**: User selects workspace (dev/staging/production)
3. **Dynamic Lookup**: `lookup()` function retrieves the correct instance type
4. **Module Invocation**: EC2 module creates instance with environment-specific values
5. **State Isolation**: Each workspace maintains separate state files

## ✅ Benefits of This Approach

- ✨ Single codebase for all environments
- 🔒 Isolated state files prevent accidental changes
- 🚀 Easy to scale to more environments
- 🎯 Environment-specific configurations without code duplication
- 🛡️ Reduced risk of configuration drift

## 🚨 Important Notes

- Always verify the current workspace before applying changes: `terraform workspace show`
- Each workspace has its own state file in `terraform.tfstate.d/`
- Cannot delete the `default` workspace
- Cannot delete the currently selected workspace
- Workspaces are stored locally unless using remote backends

## 🔗 Resources Created

- AWS EC2 Instance (size varies by workspace)
- Deployed in us-east-1 region
- Uses specified AMI and subnet from terraform.tfvars
