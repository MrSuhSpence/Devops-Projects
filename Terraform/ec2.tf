# 1. Fetch the latest Amazon Linux 2023 AMI dynamically for your region
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-kernel-6.1-x86_64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 2. Your updated EC2 instance pointing to the data source
resource "aws_instance" "pipelineEc2" {
  ami                    = data.aws_ami.latest_amazon_linux.id # <-- Changed to dynamic lookup
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer_key.key_name
  vpc_security_group_ids = [aws_security_group.web_and_ansible_sg.id]

  tags = {
    Name = "pipelineinstance"
  }
}