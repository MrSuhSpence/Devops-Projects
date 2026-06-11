terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" 
}

# Automatically looks up your default AWS network settings
data "aws_vpc" "default" {
  default = true
}

# Automatically finds the official Ubuntu 22.04 LTS operating system image
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

# Creates the firewall rules (Security Group)
resource "aws_security_group" "web_ssh_access" {
  name        = "allow_web_and_ssh"
  description = "Allow inbound HTTP and SSH traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-ssh-security-group"
  }
}

# Automatically uploads your public key format string directly into AWS
resource "aws_key_pair" "imported_key" {
  key_name   = "devops-automation-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/lMwDml3jh3aEqs01nOCKfTFXYM4TGllMeJUR69QOYQV3M42ODNE103bht3Apzp4cqrzzzQt9sn8MsDYVD9U91Ck0eqpSRMeIh+P6GnkCRJsNITSDbZaiOwEkeBJKQlJUen+/sngpTyzLRYLljMIqh2FtlnN+zW2vzoESPukw64dHj6/tFMZTuCdU8u95maKELBP5GIZdKj7rzas5aGS9e8tp9RcDAUQiNGr4qfdsJFi6KT+xe52xRNlcwv4kcWLyW7/xZXrQOz41qzcjwIWw1HBungjS8u8njiEXBo+j09KUklvpJP/ZGY1jv1JnOSjPvqGBGnhen146W5rXcbSd"
}

# Launches the virtual machine (EC2 Instance)
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  
  # Uses the dynamically imported key pair from above
  key_name      = aws_key_pair.imported_key.key_name 

  # Attaches the firewall group we defined above
  vpc_security_group_ids = [aws_security_group.web_ssh_access.id]

  tags = {
    Name = "Ansible-Target-Server"
  }
}

# Displays the Security Group ID in your terminal after apply
output "security_group_id" {
  value = aws_security_group.web_ssh_access.id
}

# Displays your server's new public IP address automatically!
output "instance_public_ip" {
  value = aws_instance.web_server.public_ip
}