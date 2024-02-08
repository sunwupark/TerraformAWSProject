

resource "aws_instance" "cicd" {
  ami           = "ami-0f3a440bbcff3d043"
  instance_type = "t3.micro"
  key_name = aws_key_pair.cicd_make_keypair.key_name
  vpc_security_group_ids = [aws_security_group.cicd_sg.id]
  subnet_id = aws_subnet.cicd_subnet.id
  # availability_zone = "ap-northeast-2a"
  associate_public_ip_address = true

  tags = {
    Name = "cicd"
  }
}

resource "tls_private_key" "cicd_make_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "cicd_make_keypair" {
  key_name   = "cicd_key"
  public_key = tls_private_key.cicd_make_key.public_key_openssh
}

resource "local_file" "cicd_downloads_key" {
  filename = "cicd_key.pem"
  content  = tls_private_key.cicd_make_key.private_key_pem
}

resource "aws_internet_gateway" "cicd_igw" {
  vpc_id = aws_vpc.cicd_vpc.id

  tags = {
    Name = "cicd-igw"
  }
}

resource "aws_route_table" "cicd_rt" {
  vpc_id = aws_vpc.cicd_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cicd_igw.id
  }

  tags = {
    Name = "cicd-rt"
  }
}

resource "aws_route_table_association" "cicd_rta" {
  subnet_id      = aws_subnet.cicd_subnet.id
  route_table_id = aws_route_table.cicd_rt.id
}

resource "aws_security_group" "cicd_sg" {
  name_prefix = "cicd-sg"
  vpc_id = aws_vpc.cicd_vpc.id
}

resource "aws_security_group_rule" "cicd_sg_ingress_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["218.237.59.119/32"]
  security_group_id = aws_security_group.cicd_sg.id
}

resource "aws_security_group_rule" "cicd_sg_ingress_https" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["218.237.59.119/32"]
  security_group_id = aws_security_group.cicd_sg.id
}

resource "aws_security_group_rule" "cicd_sg_ingress_internal" {
  type               = "ingress"
  from_port          = 0
  to_port            = 0
  protocol           = "-1"
  source_security_group_id = aws_security_group.cicd_sg.id
  security_group_id  = aws_security_group.cicd_sg.id
}

resource "aws_security_group_rule" "cicd_sg_egress_all" {
  type             = "egress"
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cicd_sg.id
}

resource "aws_vpc" "cicd_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "cicd-vpc"
  }
}

resource "aws_subnet" "cicd_subnet" {
  cidr_block = "10.0.1.0/24"
  vpc_id     = aws_vpc.cicd_vpc.id

  tags = {
    Name = "cicd-subnet"
  }
}