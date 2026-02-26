# Variables - Like Fill-in-the-Blanks! 📝

## What Are Variables?

Remember those Mad Libs games where you fill in blanks? "The [adjective] [noun] went to the [place]."

**Variables in Terraform** work the same way! Instead of writing the same thing over and over, you create blanks that can be filled with different values.

## Two Types of Variables

### 1. Input Variables (Information Going IN) ⬇️

These are like questions you ask: "What size shirt do you want?" "What color?"

```hcl
variable "example_var" {
  description = "An example input variable"
  type        = string
  default     = "default_value"
}
```

**Breaking it down:**
- `variable` = "I'm creating a blank to fill in"
- `description` = "What is this blank for?"
- `type` = "What kind of answer? (text, number, list)"
- `default` = "If nobody answers, use this"

**Using the variable:**

```hcl
resource "example_resource" "example" {
  name = var.example_var
  # other resource configurations
}
```

You use `var.example_var` to get the value - like reading the answer someone wrote!

### 2. Output Variables (Information Going OUT) ⬆️

These are like showing your finished homework to your teacher. You're sharing results!

```hcl
output "example_output" {
  description = "An example output variable"
  value       = resource.example_resource.example.id
}
```

**What's happening?**
- `output` = "I want to show this information"
- `description` = "What am I showing?"
- `value` = "Here's the actual information"

## Using Outputs from Other Modules

If you have outputs in a module (like a separate folder), you can use them:

```hcl
output "root_output" {
  value = module.example_module.example_output
}
```

It's like asking your friend: "Hey, what answer did you get for question 5?"

## Real-World Example 🌍

Think of ordering pizza:
- **Input variables**: Size (large/small), toppings (pepperoni/cheese), delivery address
- **Output variables**: Order number, delivery time, total cost

You give information IN (your order), and get information OUT (confirmation details)!

## Key Takeaway 🎯

- **Input variables** = Questions you answer (settings you provide)
- **Output variables** = Results you share (information you get back)

Variables make your code reusable - like a template you can use again and again with different answers!