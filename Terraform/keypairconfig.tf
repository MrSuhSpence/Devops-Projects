# 1. Dynamically generate a brand new, secure private key
resource "tls_private_key" "dynamic_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# 2. Push the public key half up to AWS
resource "aws_key_pair" "deployer_key" {
  key_name   = "my-dynamic-aws-key"
  public_key = tls_private_key.dynamic_key.public_key_openssh
}

# 3. Download the private key half (.pem file) to your local machine so you can use it
resource "local_file" "local_pem_file" {
  filename        = "${path.module}/my-dynamic-aws-key.pem"
  content         = tls_private_key.dynamic_key.private_key_pem
  file_permission = "0400" # Crucial: SSH will reject keys that are too openly readable
}
