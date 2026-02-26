# Conditional Expressions - Making Decisions! 🤔

## What Are Conditional Expressions?

Remember playing "If-Then" games? "If it's raining, then bring an umbrella. Otherwise, bring sunglasses."

**Conditional expressions** in Terraform work exactly like that! They help Terraform make decisions.

## The Basic Formula

```hcl
condition ? true_val : false_val
```

**Translation:** "If condition is true, use true_val. Otherwise, use false_val."

**Think of it like:**
- **condition**: The question ("Is it raining?")
- **true_val**: What to do if YES ("Bring umbrella")
- **false_val**: What to do if NO ("Bring sunglasses")

## Real Examples

### Example 1: Should We Create a Computer? 💻

```hcl
resource "aws_instance" "example" {
  count = var.create_instance ? 1 : 0

  ami           = "ami-XXXXXXXXXXXXXXXXX"
  instance_type = "t2.micro"
}
```

**What's happening?**
- If `create_instance` is true → Create 1 computer
- If `create_instance` is false → Create 0 computers (skip it!)

**Like saying:** "If mom says yes, buy 1 toy. If mom says no, buy 0 toys."

### Example 2: Which Network to Use? 🌐

```hcl
variable "environment" {
  description = "Environment type"
  type        = string
  default     = "development"
}

variable "production_subnet_cidr" {
  description = "CIDR block for production subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "development_subnet_cidr" {
  description = "CIDR block for development subnet"
  type        = string
  default     = "10.0.2.0/24"
}

resource "aws_security_group" "example" {
  name        = "example-sg"
  description = "Example security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.environment == "production" ? [var.production_subnet_cidr] : [var.development_subnet_cidr]
  }
}
```

**What's happening?**
- If environment is "production" → Use production network
- If environment is NOT "production" → Use development network

**Like saying:** "If it's a school day, wear uniform. Otherwise, wear casual clothes."

### Example 3: Should We Allow SSH Access? 🔐

```hcl
resource "aws_security_group" "example" {
  name = "example-sg"
  description = "Example security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.enable_ssh ? ["0.0.0.0/0"] : []
  }
}
```

**What's happening?**
- If `enable_ssh` is true → Allow SSH from anywhere
- If `enable_ssh` is false → Don't allow any SSH (empty list [])

**Like saying:** "If the door is unlocked, anyone can enter. If locked, nobody can enter."

## Why Use Conditional Expressions? 🎯

1. **Flexibility**: Same code works for different situations
2. **Smart decisions**: Terraform can adapt based on conditions
3. **Less code**: One smart line instead of many duplicate lines
4. **Reusability**: Use the same code for dev, test, and production

## Real-World Analogy 🌍

Think of a thermostat:
- **Condition**: Is temperature below 68°F?
- **If YES**: Turn on heater
- **If NO**: Keep heater off

Conditional expressions make your Terraform code smart like a thermostat!

## Key Takeaway 💡

Conditional expressions = "If-Then-Else" logic

Format: `condition ? do_this_if_true : do_this_if_false`

They help Terraform make smart decisions automatically!