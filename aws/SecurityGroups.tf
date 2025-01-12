#security group and rule
resource "aws_security_group" "instance_security_group" {
  name        = "instance_security_group"
  description = "Allow security rules for ec2 instance"
  vpc_id      = aws_vpc.project_vpc.id

  tags = {
    Name = "Allow inbound and outbound rules"
  }
}

#Security rules for instance
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_my_ip" {
  security_group_id = aws_security_group.instance_security_group.id
  cidr_ipv4         = "175.157.23.47/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22

  tags = {
    Name = "Allow SSH from my ip"
  }
}

# Allow SSH from the Ansible security group
resource "aws_security_group_rule" "allow_ssh_from_ansible_sg" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.instance_security_group.id
  source_security_group_id = aws_security_group.ansible_sg.id

  description = "Allow SSH from Ansible security group"
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.instance_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

  tags = {
    Name = "Allow HTTP"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_icmp" {
  security_group_id = aws_security_group.instance_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = -1
  to_port           = -1
  ip_protocol       = "icmp"

  tags = {
    Name = "Allow ICMP"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_traffic" {
  security_group_id = aws_security_group.instance_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "Allow all outbound traffic"
  }
}


#scurity group for application load balancer
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow security rules for application load balancer"
  vpc_id      = aws_vpc.project_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

#ansible security group
resource "aws_security_group" "ansible_sg" {
  name        = "ansible_sg"
  description = "Allow security rules for ansible"
  vpc_id      = aws_vpc.project_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_my_ip" {
  security_group_id = aws_security_group.ansible_sg.id
  cidr_ipv4         = "175.157.23.47/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22

  tags = {
    Name = "Allow SSH from my ip"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ansible" {
  security_group_id = aws_security_group.ansible_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

  tags = {
    Name = "Allow http ansible"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_ansible_outbound" {
  security_group_id = aws_security_group.ansible_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "Allow SSH from my ip"
  }
}
