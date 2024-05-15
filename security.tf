// default security group
resource "aws_default_security_group" "side_effect_default" {
  vpc_id = aws_vpc.side_effect.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security by terraform"
  }
}

resource "aws_default_network_acl" "side_effect_default" {
  default_network_acl_id = aws_vpc.side_effect.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "default network acl"
  }
}

// network acl for public subnets
resource "aws_network_acl" "side_effect_public" {
  vpc_id = aws_vpc.side_effect.id
  subnet_ids = [
    aws_subnet.side_effect_public_subnet1.id,
    aws_subnet.side_effect_public_subnet2.id,
  ]

  tags = {
    Name = "public"
  }
}

resource "aws_network_acl_rule" "side_effect_public_ingress80" {
  network_acl_id = aws_network_acl.side_effect_public.id
  rule_number = 100
  rule_action = "allow"
  egress = false
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 80
  to_port = 80
}

resource "aws_network_acl_rule" "side_effect_public_egress80" {
  network_acl_id = aws_network_acl.side_effect_public.id
  rule_number = 100
  rule_action = "allow"
  egress = true
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 80
  to_port = 80
}

resource "aws_network_acl_rule" "side_effect_public_ingress443" {
  network_acl_id = aws_network_acl.side_effect_public.id
  rule_number = 110
  rule_action = "allow"
  egress = false
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 443
  to_port = 443
}

resource "aws_network_acl_rule" "side_effect_public_egress443" {
  network_acl_id = aws_network_acl.side_effect_public.id
  rule_number = 110
  rule_action = "allow"
  egress = true
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 443
  to_port = 443
}

resource "aws_network_acl_rule" "side_effect_public_ingress22" {
  network_acl_id = aws_network_acl.side_effect_public.id
  rule_number = 120
  rule_action = "allow"
  egress = false
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 22
  to_port = 22
}

resource "aws_network_acl_rule" "side_effect_public_egress22" {
  network_acl_id = aws_network_acl.side_effect_public.id
  rule_number = 120
  rule_action = "allow"
  egress = true
  protocol = "tcp"
  cidr_block = aws_vpc.side_effect.cidr_block
  from_port = 22
  to_port = 22
}

resource "aws_network_acl_rule" "side_effect_public_ingress_ephemeral" {
  network_acl_id = aws_network_acl.side_effect_public.id
  rule_number = 140
  rule_action = "allow"
  egress = false
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 1024
  to_port = 65535
}

resource "aws_network_acl_rule" "side_effect_public_egress_ephemeral" {
  network_acl_id = aws_network_acl.side_effect_public.id
  rule_number = 140
  rule_action = "allow"
  egress = true
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 1024
  to_port = 65535
}

resource "aws_network_acl_rule" "side_effect_public_ingress8080" {
  network_acl_id = aws_network_acl.side_effect_public.id
  rule_number = 160
  rule_action = "allow"
  egress = false
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 8080
  to_port = 8080
}

resource "aws_network_acl_rule" "side_effect_public_egress8080" {
  network_acl_id = aws_network_acl.side_effect_public.id
  rule_number = 160
  rule_action = "allow"
  egress = true
  protocol = "tcp"
  cidr_block = aws_vpc.side_effect.cidr_block
  from_port = 8080
  to_port = 8080
}

resource "aws_network_acl_rule" "side_effect_public_ingress5439" {
  network_acl_id = aws_network_acl.side_effect_public.id
  rule_number = 180
  rule_action = "allow"
  egress = false
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 5439
  to_port = 5439
}

resource "aws_network_acl_rule" "side_effect_public_egress5439" {
  network_acl_id = aws_network_acl.side_effect_public.id
  rule_number = 180
  rule_action = "allow"
  egress = true
  protocol = "tcp"
  cidr_block = aws_vpc.side_effect.cidr_block
  from_port = 5439
  to_port = 5439
}

resource "aws_network_acl_rule" "side_effect_public_ingress3306" {
  network_acl_id = aws_network_acl.side_effect_public.id
  rule_number = 200
  rule_action = "allow"
  egress = false
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 3306
  to_port = 3306
}

resource "aws_network_acl_rule" "side_effect_public_egress3306" {
  network_acl_id = aws_network_acl.side_effect_public.id
  rule_number = 200
  rule_action = "allow"
  egress = true
  protocol = "tcp"
  cidr_block = aws_vpc.side_effect.cidr_block
  from_port = 3306
  to_port = 3306
}

// network acl for private subnets
resource "aws_network_acl" "side_effect_private" {
  vpc_id = aws_vpc.side_effect.id
  subnet_ids = [
    aws_subnet.side_effect_private_subnet1.id,
    aws_subnet.side_effect_private_subnet2.id
  ]
  tags = {
    Name = "private"
  }
}

resource "aws_network_acl_rule" "side_effect_private_ingress_vpc" {
  network_acl_id = aws_network_acl.side_effect_private.id
  rule_number = 100
  rule_action = "allow"
  egress = false
  protocol = -1
  cidr_block = aws_vpc.side_effect.cidr_block
  from_port = 0
  to_port = 0
}

resource "aws_network_acl_rule" "side_effect_private_egress_vpc" {
  network_acl_id = aws_network_acl.side_effect_private.id
  rule_number = 100
  rule_action = "allow"
  egress = true
  protocol = -1
  cidr_block = aws_vpc.side_effect.cidr_block
  from_port = 0
  to_port = 0
}

resource "aws_network_acl_rule" "side_effect_private_ingress_nat" {
  network_acl_id = aws_network_acl.side_effect_private.id
  rule_number = 110
  rule_action = "allow"
  egress = false
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 1024
  to_port = 65535
}

resource "aws_network_acl_rule" "side_effect_private_egress80" {
  network_acl_id = aws_network_acl.side_effect_private.id
  rule_number = 120
  rule_action = "allow"
  egress = true
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 80
  to_port = 80
}

resource "aws_network_acl_rule" "side_effect_private_egress8080" {
  network_acl_id = aws_network_acl.side_effect_private.id
  rule_number = 130
  rule_action = "allow"
  egress = true
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 8080
  to_port = 8080
}

resource "aws_network_acl_rule" "side_effect_private_egress443" {
  network_acl_id = aws_network_acl.side_effect_private.id
  rule_number = 140
  rule_action = "allow"
  egress = true
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 443
  to_port = 443
}

// Basiton Host
resource "aws_security_group" "side_effect_bastion" {
  name = "meme_security"
  description = "Security group for bastion instance"
  vpc_id = aws_vpc.side_effect.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 5439
    to_port = 5439
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2_security"
  }
}