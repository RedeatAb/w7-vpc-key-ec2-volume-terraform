//create key pair 
//pluck public key in aws 
// download private key 



// create public key 
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

// public key in aws 
resource "aws_key_pair" "key1" {
  key_name   = "terraformkey"
  public_key = tls_private_key.key.public_key_openssh
}
// downloading the private key in local file 
resource "local_file" "privatekey" {
  filename        = "terraformkey.pem"
  file_permission = 0400
  content         = tls_private_key.key.private_key_openssh
}