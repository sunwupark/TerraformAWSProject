# RDS Subnet Group 생성
resource "aws_db_subnet_group" "db-subnet-group" {
  name = "meme-db-subnet-group"
  subnet_ids = [aws_subnet.db_private_subnet1.id, aws_subnet.db_private_subnet2.id]
  # 서브넷에 이미 소속 VPC, AZ 정보를 입력하여 생성하였기 때문에, 서브넷 id만 나열해주면 subnet group 생성
}

resource "aws_db_instance" "mysql_db" {
  engine               = "mysql"
  identifier           = var.DB_IDENTIFIER
  allocated_storage    =  20
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username = var.DB_USERNAME # 인스턴스에서 직접 제어되는 DB Master User Name
  password = var.DB_PASSWORD
  parameter_group_name = "default.mysql8.0"
  vpc_security_group_ids = [aws_security_group.rds_security.id] # db 보안그룹 지정
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.db-subnet-group.name # DB가 배치될 서브넷 그룹(.name으로 지정)
}

output "rds_writer_endpoint" { # rds cluster의 writer 인스턴스 endpoint 추출 (mysql 설정 및 Three-tier 연동파일에 정보 입력 필요해서 추출)
  value = aws_db_instance.mysql_db.endpoint # 해당 추출값은 terraform apply 완료 시 또는 terraform output rds_writer_endpoint로 확인 가능
}