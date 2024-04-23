resource "aws_lambda_function" "terraform_lambda_func" {
  s3_bucket = "meme-terraform-state-saving"
  s3_key = "authorizer.zip"
  function_name                  = "JWTAuthorizer"
  role                           = aws_iam_role.lambda_role.arn
  handler                        = "index.lambda_handler"
  runtime                        = "nodejs16.x"
  depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}