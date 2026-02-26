# Multiple Providers - Using Different Cloud Services Together! 🌐

## What Does This Mean?

Imagine you have toys from different stores - some from Target, some from Walmart. You can play with all of them together, right?

Same way, you can use **multiple cloud providers** in one Terraform project! You can create things in AWS AND Azure at the same time.

## How to Set It Up

### Step 1: Create a providers.tf file
This is like making a list of all the stores you'll shop from.

### Step 2: Define your providers

```hcl
provider "aws" {
  region = "us-east-1"
}

provider "azurerm" {
  subscription_id = "your-azure-subscription-id"
  client_id = "your-azure-client-id"
  client_secret = "your-azure-client-secret"
  tenant_id = "your-azure-tenant-id"
}
```

**What's happening?**
- We're telling Terraform: "We'll use both AWS and Azure!"
- Each provider needs its own login information (like usernames and passwords)

### Step 3: Create resources in both clouds

```hcl
resource "aws_instance" "example" {
  ami = "ami-0123456789abcdef0"
  instance_type = "t2.micro"
}

resource "azurerm_virtual_machine" "example" {
  name = "example-vm"
  location = "eastus"
  size = "Standard_A1"
}
```

**Cool, right?** Now you're creating a computer in AWS AND a computer in Azure with the same Terraform code! 🎉