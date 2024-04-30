resource "aws_api_gateway_domain_name" "api" {
  domain_name = var.GATEWAY_DNS
  regional_certificate_arn = aws_acm_certificate_validation.api.certificate_arn
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_route53_record" "sangchulkr_sub1" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = var.GATEWAY_DNS
  type    = "A"
  alias {
    name                   = aws_api_gateway_domain_name.api.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.api.regional_zone_id
    evaluate_target_health = true
  }
}

resource "aws_api_gateway_base_path_mapping" "example" {
  api_id      = aws_api_gateway_rest_api.meme_gateway.id
  stage_name  = aws_api_gateway_deployment.meme_gateway.stage_name
  domain_name = aws_api_gateway_domain_name.api.domain_name
}