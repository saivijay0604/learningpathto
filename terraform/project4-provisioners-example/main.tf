# Configure AWS provider
provider "aws" {
    region = "us-east-1"  # AWS region where resources will be created
}

# Define CIDR block variable for VPC
variable "cidr"{
    description = "CIDR block for the VPC"
    default = "10.0.0.0/16"  # Default VPC CIDR range
}

# Create VPC (Virtual Private Cloud)
resource "aws_vpc" "myfirstVPC" {
    cidr_block = var.cidr  # Use the CIDR block from variable
}

# Create SSH key pair for EC2 instance access
resource "aws_key_pair" "keypair" {
  key_name =  "terraform-demo-vijay"  # Name of the key pair in AWS
  public_key = file("~/.ssh/id_rsa.pub")  # Path to public key file
}

# Create public subnet within the VPC
resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.myfirstVPC.id  # Reference to VPC created above
    cidr_block = "10.0.1.0/24"  # Subnet CIDR range (subset of VPC CIDR)
    availability_zone = "us-east-1a"  # Specific AZ for the subnet
    map_public_ip_on_launch = true  # Auto-assign public IP to instances
}

# Create Internet Gateway for VPC internet access
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.myfirstVPC.id  # Attach IGW to VPC
  
}

# Create route table for public internet access
resource "aws_route_table" "public-route-tabel" {
    vpc_id = aws_vpc.myfirstVPC.id  # Associate route table with VPC

    route {
        cidr_block = "0.0.0.0/0"  # Route all traffic (default route)
        gateway_id = aws_internet_gateway.igw.id  # Send traffic to Internet Gateway
    }
}


# Associate route table with subnet
resource "aws_route_table_association" "rta1" {
    subnet_id = aws_subnet.subnet1.id  # Subnet to associate
    route_table_id = aws_route_table.public-route-tabel.id  # Route table to use
}


# Create security group with firewall rules
resource "aws_security_group" "allow_ssh" {
    name ="web"  # Security group name
    vpc_id = aws_vpc.myfirstVPC.id  # Attach to VPC

    # Allow SSH access (port 22)
    ingress{
        description = "SSH from VPC"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # Allow from anywhere (use specific IP in production)
    }

    # Allow HTTP access (port 80)
    ingress{
        description = "HTTP from VPC"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # Allow from anywhere
    }

    # Allow Go app access (port 8080)
    ingress{
        description = "Go App"
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # Allow from anywhere
    }

    # Allow all outbound traffic
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"  # -1 means all protocols
        cidr_blocks = ["0.0.0.0/0"]  # Allow to anywhere

    }

    tags = {
        Name= "web-sg"  # Tag for identification
    }

}

# Create EC2 instance and deploy Go application
resource "aws_instance" "webserver" {
    ami = "ami-0199fa5fada510433"  # Amazon Linux 2 AMI ID
    instance_type = "t2.micro"  # Instance size (free tier eligible)
    key_name = aws_key_pair.keypair.key_name  # SSH key for access
    vpc_security_group_ids = [aws_security_group.allow_ssh.id]  # Attach security group
    subnet_id = aws_subnet.subnet1.id  # Launch in public subnet

    # SSH connection configuration for provisioners
    connection {
      type = "ssh"  # Connection type
      user = "ec2-user"  # Default user for Amazon Linux
      private_key = file("~/.ssh/id_rsa")  # Path to private key
      host = self.public_ip  # Use instance's public IP
    }

    # Copy Go application file to EC2 instance
    provisioner "file"{
        source = "app.go"  # Local file path
        destination = "/home/ec2-user/app.go"  # Remote destination path
    
    }

    # Execute commands on EC2 instance after creation
    provisioner "remote-exec"{
        inline = [
            "echo 'Hello from the remote instance'",  # Print welcome message
            "sudo yum install -y golang",  # Install Go programming language
            "cd /home/ec2-user",  # Change to home directory
            "nohup go run app.go > app.log 2>&1 &",  # Run Go app in background
            "sleep 2"  # Wait for app to start
        ]
    }
}


