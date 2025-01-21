resource "aws_instance" "bastion" {
  ami           = "ami-064519b8c76274859"
  instance_type = var.instance
  key_name      = var.key_name

  subnet_id = aws_subnet.public.id

  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "BastionHost"
  }
}

resource "aws_instance" "web_server" {
  ami           = "ami-064519b8c76274859"
  instance_type = var.instance
  key_name      = var.key_name

  subnet_id = aws_subnet.private.id

  vpc_security_group_ids = [aws_security_group.web_server_sg.id]

  tags = {
    Name = "WebServer"
  }
}

resource "aws_instance" "private_server" {
  ami           = "ami-064519b8c76274859"
  instance_type = var.instance
  key_name      = var.key_name

  subnet_id = aws_subnet.private.id

  vpc_security_group_ids = [aws_security_group.private_server_sg.id]

  tags = {
    Name = "Private Server"
  }
}