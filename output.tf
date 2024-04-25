output "elastic-ip-auth" { # rds cluster의 writer 인스턴스 endpoint 추출 (mysql 설정 및 Three-tier 연동파일에 정보 입력 필요해서 추출)
  value = aws_eip.meme_auth_ec2.public_ip
}

output "elastic-ip-service" { # rds cluster의 writer 인스턴스 endpoint 추출 (mysql 설정 및 Three-tier 연동파일에 정보 입력 필요해서 추출)
  value = aws_eip.meme_service_ec2.public_ip
}
