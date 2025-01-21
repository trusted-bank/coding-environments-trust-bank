output "instance_public_ip_bastion" {
  value = aws_instance.bastion.public_ip
}

output "instance_private_ip_web_server" {
  value = aws_instance.web_server.private_ip
}

output "instance_private_ip_private_server" {
  value = aws_instance.private_server.private_ip
}
