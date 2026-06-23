
data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "web_and_ansible_sg" {
  name        = "ansible-apache-firewall"
  description = "Allow SSH for Ansible and HTTP for Apache web traffic"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "AnsibleApacheSG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.web_and_ansible_sg.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
  description       = "SSH access for Ansible control node"
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.web_and_ansible_sg.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Web traffic for Apache container"
}


resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.web_and_ansible_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
