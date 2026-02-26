# Terraform tfvars - Your Answer Sheet! 📋

## What Are .tfvars Files?

Imagine you have a test with fill-in-the-blank questions. The test is the same for everyone, but each person writes different answers on their answer sheet.

**That's what .tfvars files are!** They're your answer sheets for Terraform variables.

## Why Use .tfvars Files? 🤔

### 1. Keep Answers Separate from Questions

Instead of writing answers directly in your code, you keep them in a separate file. This makes it easier to:
- Use the same code with different answers
- Change answers without touching the code

### 2. Store Secret Information Safely 🔐

.tfvars files are perfect for storing:
- Passwords
- API keys
- Secret tokens

You can keep these files private and NOT share them on GitHub!

### 3. Reuse the Same Code ♻️

One set of Terraform code + Different .tfvars files = Different environments!

**Example:**
- `dev.tfvars` - for development (testing)
- `staging.tfvars` - for staging (practice)
- `prod.tfvars` - for production (real thing)

### 4. Team Collaboration 👥

Each team member can have their own .tfvars file with their personal settings, without messing up others' work!

## How to Use .tfvars Files

### Step 1: Define Variables in Your Code

In your `variables.tf` file:
```hcl
variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}
```

### Step 2: Create a .tfvars File

Create `dev.tfvars`:
```hcl
instance_type = "t2.micro"
region        = "us-east-1"
```

Create `prod.tfvars`:
```hcl
instance_type = "t2.large"
region        = "us-west-2"
```

### Step 3: Use the .tfvars File

When running Terraform:
```bash
terraform apply -var-file=dev.tfvars
```

Or for production:
```bash
terraform apply -var-file=prod.tfvars
```

## Real-World Example 🌍

Think of it like ordering at a restaurant:
- **Menu (Terraform code)**: Same for everyone
- **Order form (.tfvars file)**: Each person fills out their own
- **Your meal**: Customized based on your order form!

## Key Takeaway 🎯

.tfvars files let you:
- ✅ Keep code and configuration separate
- ✅ Protect sensitive information
- ✅ Reuse the same code for different environments
- ✅ Work better in teams

**Remember:** The code asks questions, .tfvars files provide answers!