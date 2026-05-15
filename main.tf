provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "web_access" {
  name = "allow_ssh_http"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
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
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key-unique"
  public_key = file("./my-aws-key.pub")
}

resource "aws_instance" "web_server" {
  ami           = "ami-0440d3b780d96b29d" # Amazon Linux 2023
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.web_access.id]
  associate_public_ip_address = true
}

output "instance_ip" {
  value = aws_instance.web_server.public_ip
}
