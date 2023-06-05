resource "aws_key_pair" "web_admin" {
  key_name = "web_admin"
  public_key = file("~/.ssh/web_admin.pub")
}

resource "aws_security_group" "ssh" {
  name = "allow_ssh_from_all"
  description = "Allow SSH port from all"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#data 는 default인 시큐리티 그룹을 찾아 해당 리소스의 속성들을 참조
data "aws_security_group" "default" {
  name = "default"
}


# VPC가 하나가 아니거나 별도로 default같은 이름으로 시큐리티 그룹을
#생성한 적이 있다면 찾고자 하는 리소스를 정확하게 사용하기 위하여
#data "aws_security_group" "default" {
#  name = "default"
#  id = "<SECURITY_GROUP_ID>"
#}

#EC2 instance를 정의하는 리소스는 aws_instance이다. 
resource "aws_instance" "web" {
  ami = "ami-0a93a08544874b3b7" # amzn2-ami-hvm-2.0.20200207.1-x86_64-gp2
  instance_type = "t2.micro"
  key_name = aws_key_pair.web_admin.key_name #다른 리소스의 속성 참조 가능/ 간접적 의존 관계
  vpc_security_group_ids = [
    aws_security_group.ssh.id,
    data.aws_security_group.default.id
  ]
}

#WS가 직접 관리해주는 데이터베이스 서비스 RDS의 MySQL 리소스를 생성
resource "aws_db_instance" "web_db" {
  allocated_storage = 8 #할당할 용량
  engine = "mysql" #데이터베이스 엔진
  engine_version = "5.6.35" 
  instance_class = "db.t2.micro" #인스턴스 타입
  username = "admin" #계정이륾
  password = "park13579@" #사용할 암호로 적절히 변경한다, 
  skip_final_snapshot = true #인스턴스 제거시 최종 스냅샷 만들지 여부
}
