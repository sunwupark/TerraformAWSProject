resource "aws_elasticache_subnet_group" "example" {
  name       = "my-cache-subnet"
  subnet_ids = [aws_subnet.side_effect_private_subnet1.id, aws_subnet.side_effect_private_subnet2.id]
}

resource "aws_elasticache_replication_group" "elasticache_cluster" {
  replication_group_id       = "tf-redis-cluster"
  description                = "MeMe-ElastiCache"
  node_type                  = "cache.t2.micro"
  port                       = 6379
  parameter_group_name = "default.redis7"
  engine_version       = "7.1"
  subnet_group_name    = aws_elasticache_subnet_group.example.name
  security_group_ids   = [aws_security_group.elasticache_security.id]
  num_cache_clusters = 1
}


output "elasticache_endpoint" { # cache cluster의 writer 인스턴스 endpoint 추출 (mysql 설정 및 Three-tier 연동파일에 정보 입력 필요해서 추출)
  value = aws_elasticache_replication_group.elasticache_cluster.configuration_endpoint_address # 해당 추출값은 terraform apply 완료 시 또는 terraform output rds_writer_endpoint로 확인 가능
}