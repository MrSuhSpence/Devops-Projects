# ==============================================================================
# 1. AUTOMATED KEYPAIR GENERATION
# ==============================================================================

# Generates a secure, cryptographic private key dynamically inside Terraform
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Registers the public portion of the generated key with AWS EC2
resource "aws_key_pair" "generated_key" {
  key_name   = "codespaces-ec2-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

# Saves the private portion (.pem) to your local Codespace directory for Ansible
resource "local_file" "ssh_key" {
  filename        = "${path.module}/codespaces-ec2-key.pem"
  content         = tls_private_key.ec2_key.private_key_pem
  file_permission = "0400" # Sets read-only permissions required by SSH
}

# ==============================================================================
# 2. NETWORKING & SECURITY CONFIGURATION
# ==============================================================================

# Creates a Security Group to allow inbound SSH traffic so Ansible can connect
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_default"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ==============================================================================
# 3. MACHINE IMAGE & EC2 INSTANCE PROVISIONING
# ==============================================================================

# Dynamic lookup to always pull the latest official Ubuntu 22.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's official AWS ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Deploys the EC2 Instance using the dynamic AMI and the automated key pair
resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "Ansible-Target-Node"
  }
}