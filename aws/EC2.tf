#ansible server
resource "aws_instance" "ansible_server" {
  ami                    = "ami-0e2c8caa4b6378d8c"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.ec2_key_pair.key_name
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.ansible_sg.id]

  tags = {
    Name = "Ansible Server"
  }
}

output "ansible_server_public_ip" {
  value = aws_instance.ansible_server.public_ip
}

#web01
resource "aws_instance" "web01" {
  ami                    = "ami-0e2c8caa4b6378d8c"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.ec2_key_pair.key_name
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.instance_security_group.id]

  tags = {
    Name = "web01"
  }
}

output "web01_public_ip" {
  value = aws_instance.web01.public_ip
}


#web02
resource "aws_instance" "web02" {
  ami                    = "ami-0e2c8caa4b6378d8c"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.ec2_key_pair.key_name
  subnet_id              = aws_subnet.public_subnet_2.id
  vpc_security_group_ids = [aws_security_group.instance_security_group.id]

  tags = {
    Name = "web02"
  }
}

output "web02_public_ip" {
  value = aws_instance.web02.public_ip
}
