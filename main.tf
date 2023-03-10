# ------------
# EC2 instance
resource "aws_instance" "jklug-EC2" {
  ami = "ami-0557a15b87f6559cf"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.jklug-EC2-SG.id] # SG
  key_name = aws_key_pair.ssh-key-public.key_name # SSH key
  
  tags = {
    Name = "jklug-EC2"
  }

 # Copy Script to EC2 Instance 
 provisioner "file" {
  source      = "install_docker.sh"
  destination = "/home/ubuntu/install_docker.sh"
 }
 
 # Change Script permission, run script
 provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/install_docker.sh",
      "sudo /home/ubuntu/install_docker.sh",
    ]
  }
  
  # SSH Connection
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("terraform_aws_jk")
    host        = aws_instance.jklug-EC2.public_ip
    }
}
# End of EC2 Instance
# -------------------

# SSH Key (same folder as main.tf)
resource "aws_key_pair" "ssh-key-public" {
    key_name = "ssh-key-public"
    public_key = file("terraform_aws_jk.pub")  # Public SSH Key
}

# Security Group
# --------------
resource "aws_security_group" "jklug-EC2-SG" {
  name = "jklug-EC2-SG"
  # Inbound: allow SSH from Anywhere
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Outbound: allow all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# End of Security Group
# --------------

