# Fetch the correct, official Amazon Linux 2023 AMI dynamically
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"] # <-- This pattern works reliably across all AWS regions
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Your EC2 instance stays exactly the same, mapping the correct parameters
resource "aws_instance" "pipelineEc2" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer_key.key_name
  vpc_security_group_ids = [aws_security_group.web_and_ansible_sg.id]

  tags = {
    Name = "pipelineinstance"
  }
}