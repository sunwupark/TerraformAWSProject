#resource "aws_iam_policy" "cortex_auto_scale_policy" {
#  name        = "cortex_auto_scale_policy"
#  path        = "/"
#  description = "auto scale policy for cortex cluster"
#  policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#      {
#        "Effect": "Allow",
#        "Action": "*",
#        "Resource": "*"
#      }
#    ]
#  })
#}
#
#resource "aws_iam_role" "cortex_auto_scale_role" {
#  name = "cortex_auto_scale_role"
#  path = "/"
#  assume_role_policy = <<EOF
#{
#    "Version": "2012-10-17",
#    "Statement": [
#        {
#            "Effect": "Allow",
#            "Principal": {
#                "Service": "ec2.amazonaws.com"
#            },
#            "Action": "sts:AssumeRole"
#        }
#    ]
#}
#EOF
#}
#
#resource "aws_iam_role_policy_attachment" "cortex_auto_scale_role_attach" {
#  role       = aws_iam_role.cortex_auto_scale_role.name
#  policy_arn = aws_iam_policy.cortex_auto_scale_policy.arn
#}

resource "aws_iam_role" "lambda_role" {
  name   = "Lambda_Function_Role"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "iam_policy_for_lambda" {

  name         = "aws_iam_policy_for_terraform_aws_lambda_role"
  path         = "/"
  description  = "AWS IAM Policy for managing aws lambda role"
  policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role        = aws_iam_role.lambda_role.name
  policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}

