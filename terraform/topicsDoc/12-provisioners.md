# Provisioners - Setting Up Your New Computer! 🛠️

## What Are Provisioners?

Imagine you just got a new computer. It's turned on, but you need to:
- Install your favorite apps
- Copy your files to it
- Set up your settings

**Provisioners** in Terraform do exactly that! After Terraform creates a server, provisioners help you set it up and configure it.

## Three Types of Provisioners

### 1. file Provisioner - Copy Files 📁

**What it does:** Copies files from your computer to the cloud server.

**Like:** Moving your photos from your old phone to your new phone!

#### Example:

```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  provisioner "file" {
    source      = "local/path/to/localfile.txt"
    destination = "/path/on/remote/instance/file.txt"
    
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }
}
```

**What's happening:**
1. Create an EC2 instance (cloud computer)
2. Copy `localfile.txt` from your computer
3. Put it on the cloud server at `/path/on/remote/instance/file.txt`
4. Use SSH (secure connection) to transfer the file

**Real-world use:**
- Upload configuration files
- Copy scripts to run
- Transfer website files

### 2. remote-exec Provisioner - Run Commands on Cloud Server 🖥️

**What it does:** Runs commands on the cloud server (like typing commands in a terminal).

**Like:** Telling your friend over the phone: "Open the app, click settings, turn on notifications!"

#### Example:

```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }
}
```

**What's happening:**
1. Create an EC2 instance
2. Connect to it via SSH
3. Run three commands:
   - Update all software
   - Install Apache web server
   - Start the web server

**Real-world use:**
- Install software (like installing Chrome or Spotify)
- Configure settings
- Start services

**Think of it like:** Remote controlling a robot to do tasks!

### 3. local-exec Provisioner - Run Commands on YOUR Computer 💻

**What it does:** Runs commands on YOUR computer (where you're running Terraform).

**Like:** Writing yourself a reminder note after ordering something online!

#### Example:

```hcl
resource "null_resource" "example" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "echo 'Server created!' >> log.txt"
  }
}
```

**What's happening:**
1. When Terraform runs
2. Execute a command on YOUR computer
3. This example writes "Server created!" to a log file

**Real-world use:**
- Save information to a local file
- Run a local script
- Send a notification
- Update a local database

#### Another Example - Save IP Address:

```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ip_address.txt"
  }
}
```

**What's happening:** After creating the server, save its IP address to a file on your computer!

## Quick Comparison 📊

| Provisioner | Where It Runs | What It Does | Example Use |
|-------------|---------------|--------------|-------------|
| **file** | Cloud Server | Copy files | Upload config files |
| **remote-exec** | Cloud Server | Run commands | Install software |
| **local-exec** | Your Computer | Run commands | Save logs locally |

## Connection Block - How to Connect 🔌

To use `file` or `remote-exec`, you need to tell Terraform HOW to connect to the server:

```hcl
connection {
  type        = "ssh"              # Use SSH (secure connection)
  user        = "ec2-user"         # Username to login
  private_key = file("~/.ssh/id_rsa")  # Your key (like a password)
  host        = self.public_ip     # Server's address
}
```

**Like:** Giving someone your address, door code, and key so they can enter your house!

## Complete Real-World Example 🌍

Let's create a web server and set it up completely:

```hcl
resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "my-key"

  # Step 1: Copy website files to server
  provisioner "file" {
    source      = "website/"
    destination = "/tmp/website"
    
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/my-key.pem")
      host        = self.public_ip
    }
  }

  # Step 2: Install web server and move files
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo mv /tmp/website/* /var/www/html/",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/my-key.pem")
      host        = self.public_ip
    }
  }

  # Step 3: Save the server IP locally
  provisioner "local-exec" {
    command = "echo 'Web server IP: ${self.public_ip}' >> deployment.log"
  }
}
```

**What this does:**
1. 📁 Copy website files to the server
2. 🖥️ Install Apache web server on the server
3. 🖥️ Move website files to the right location
4. 🖥️ Start the web server
5. 💻 Save the server's IP address on your computer

## Important Notes ⚠️

### When to Use Provisioners:
- ✅ Quick setup tasks
- ✅ One-time configurations
- ✅ Simple installations

### When NOT to Use Provisioners:
- ❌ Complex configurations (use tools like Ansible instead)
- ❌ Things that need to run repeatedly
- ❌ If there's a better Terraform resource available

### Best Practice:
Use provisioners as a "last resort" - if there's a Terraform resource that does what you need, use that instead!

## Key Takeaway 🎯

**Provisioners = Setup helpers**

- **file** → Copy files TO the server
- **remote-exec** → Run commands ON the server
- **local-exec** → Run commands on YOUR computer

**Think of it like:**
- **file** = Packing and shipping boxes
- **remote-exec** = Remote controlling a robot
- **local-exec** = Writing in your own notebook

**Remember:** Provisioners run AFTER the resource is created, helping you set it up and configure it! 🚀
