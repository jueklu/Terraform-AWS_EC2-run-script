# Output public IP of EC2 instance
output "public_ip" {
  value = aws_instance.jklug-EC2.public_ip
  description = "EC2 public IP"
}