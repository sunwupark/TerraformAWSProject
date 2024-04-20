resource "aws_api_gateway_rest_api" "meme_gateway" {
  name = "MemeGateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "api" {
  parent_id   = aws_api_gateway_rest_api.meme_gateway.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.meme_gateway.id
  path_part   = "api"
}

resource "aws_api_gateway_resource" "v1" {
  rest_api_id = aws_api_gateway_rest_api.meme_gateway.id
  parent_id   = aws_api_gateway_resource.api.id
  path_part   = "v1"
}

resource "aws_api_gateway_resource" "auth_api" {
  rest_api_id = aws_api_gateway_rest_api.meme_gateway.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "auth"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.meme_gateway.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_resource" "signup" {
  rest_api_id = aws_api_gateway_rest_api.meme_gateway.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "signup"
}

resource "aws_api_gateway_resource" "signup_proxy" {
  rest_api_id = aws_api_gateway_rest_api.meme_gateway.id
  parent_id   = aws_api_gateway_resource.signup.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_resource" "login" {
  rest_api_id = aws_api_gateway_rest_api.meme_gateway.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "login"
}

resource "aws_api_gateway_resource" "reissue" {
  rest_api_id = aws_api_gateway_rest_api.meme_gateway.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "reissue"
}

resource "aws_api_gateway_method" "signup_method" {
  rest_api_id   = aws_api_gateway_rest_api.meme_gateway.id
  resource_id   = aws_api_gateway_resource.signup_proxy.id
  http_method   = "ANY"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_method" "login_method" {
  rest_api_id   = aws_api_gateway_rest_api.meme_gateway.id
  resource_id   = aws_api_gateway_resource.login.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "reissue_method" {
  rest_api_id   = aws_api_gateway_rest_api.meme_gateway.id
  resource_id   = aws_api_gateway_resource.reissue.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_resource" "auth_proxy" {
  rest_api_id = aws_api_gateway_rest_api.meme_gateway.id
  parent_id   = aws_api_gateway_resource.auth_api.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "api_proxy" {
  rest_api_id   = aws_api_gateway_rest_api.meme_gateway.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "JWT"
  authorizer_id = aws_api_gateway_authorizer.demo.id
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_method" "api_auth_proxy" {
  rest_api_id   = aws_api_gateway_rest_api.meme_gateway.id
  resource_id   = aws_api_gateway_resource.auth_proxy.id
  http_method   = "ANY"
  authorization = "JWT"
  authorizer_id = aws_api_gateway_authorizer.demo.id
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "SignUpIntegration" {
  rest_api_id          = aws_api_gateway_rest_api.meme_gateway.id
  resource_id          = aws_api_gateway_resource.signup_proxy.id
  http_method          = aws_api_gateway_method.signup_method.http_method
  type                 = "HTTP_PROXY"
  uri                  = "http://${aws_eip.meme_auth_ec2.public_ip}:8080/api/v1/signup/{proxy}"
  integration_http_method = "ANY"
  timeout_milliseconds = 29000

  cache_key_parameters = ["method.request.path.proxy"]

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_integration" "LoginIntegration" {
  rest_api_id          = aws_api_gateway_rest_api.meme_gateway.id
  resource_id          = aws_api_gateway_resource.login.id
  http_method          = aws_api_gateway_method.login_method.http_method
  type                 = "HTTP"
  uri                  = "http://${aws_eip.meme_auth_ec2.public_ip}:8080/api/v1/login"
  integration_http_method = "ANY"
  timeout_milliseconds = 29000
}

resource "aws_api_gateway_integration" "ReissueIntegration" {
  rest_api_id          = aws_api_gateway_rest_api.meme_gateway.id
  resource_id          = aws_api_gateway_resource.reissue.id
  http_method          = aws_api_gateway_method.reissue_method.http_method
  type                 = "HTTP"
  uri                  = "http://${aws_eip.meme_auth_ec2.public_ip}:8080/api/v1/reissue"
  integration_http_method = "ANY"
  timeout_milliseconds = 29000
}

resource "aws_api_gateway_integration" "ApiV0Integration" {
  rest_api_id          = aws_api_gateway_rest_api.meme_gateway.id
  resource_id          = aws_api_gateway_resource.auth_proxy.id
  http_method          = aws_api_gateway_method.api_auth_proxy.http_method
  type                 = "HTTP_PROXY"
  uri                  = "http://${aws_eip.meme_auth_ec2.public_ip}:8080/api/v1/auth/{proxy}"
  integration_http_method = "ANY"

  cache_key_parameters = ["method.request.path.proxy"]

  timeout_milliseconds = 29000
  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_integration" "ApiV1Integration" {
  rest_api_id          = aws_api_gateway_rest_api.meme_gateway.id
  resource_id          = aws_api_gateway_resource.proxy.id
  http_method          = aws_api_gateway_method.api_proxy.http_method
  type                 = "HTTP_PROXY"
  uri                  = "http://${aws_eip.meme_service_ec2.public_ip}:8080/api/v1/{proxy}"
  integration_http_method = "ANY"

  cache_key_parameters = ["method.request.path.proxy"]

  timeout_milliseconds = 29000
  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "meme_gateway" {
  depends_on  = [
    aws_api_gateway_integration.ApiV0Integration, aws_api_gateway_integration.ApiV1Integration,
    aws_api_gateway_integration.auth_integration, aws_api_gateway_integration.service_integration,
    aws_api_gateway_integration.SignUpIntegration, aws_api_gateway_integration.ReissueIntegration,
    aws_api_gateway_integration.LoginIntegration
  ]
  rest_api_id = aws_api_gateway_rest_api.meme_gateway.id
  stage_name    = "prod"
}

resource "aws_api_gateway_authorizer" "demo" {
  name                   = "authorizer"
  rest_api_id            = aws_api_gateway_rest_api.meme_gateway.id
  authorizer_uri         = aws_lambda_function.terraform_lambda_func.invoke_arn
  authorizer_credentials = aws_iam_role.invocation_role.arn
}

resource "aws_iam_role" "invocation_role" {
  name               = "api_gateway_auth_invocation"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.invocation_assume_role.json
}

data "aws_iam_policy_document" "invocation_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
