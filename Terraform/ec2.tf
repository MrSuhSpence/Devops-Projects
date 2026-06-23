resource "aws_instance" "pipelineEc2" {
  ami                    = "ami-091138d0f0d41ff90"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer_key.key_name
  vpc_security_group_ids = [aws_security_group.web_and_ansible_sg.id]

  tags = {
    Name = "pipelineinstance"
  }
}
