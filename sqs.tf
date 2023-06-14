provider "aws"
#aws provider 정의

#각 큐를 aws_sqs_queue 라는 resource로 정의
#redrive policy속성을 보면 ec2_monitor_dlq의 ARN이 참조 -
# -> Terraform은 리소스간의 참조 관계를 파악한 뒤, 순서에 맞게 생성/변경/삭제
# 여기저기 흩어진 값을 복사 & 붙여넣어야 했던 복잡한 인프라 구성도 한꺼번에 생성
resource "aws_sqs_queue" "ec2 monitor" {
    name = "ec2-monitor"
    redrive-policy = "", "maxReceiveCount"

    tags = {
        Team = "engineers"
    }
}

resource "aws_sqs_queue" "ec2_monitor_dlq" {
    name = "ec2-monitor-dlq"

    tags = {
        Team = "engineers"
        Type = "dlq"
    }
}

