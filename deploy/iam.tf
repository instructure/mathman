# API Gateway
resource "aws_iam_role" "api-gateway-cloudwatch-role" {
  name = "api-gateway-cloudwatch-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "api-gateway-cloudwatch-policy" {
  name = "api-gateway-cloudwatch-policy"
  role = "${aws_iam_role.api-gateway-cloudwatch-role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "logs:PutLogEvents",
        "logs:GetLogEvents",
        "logs:FilterLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# Lambda
resource "aws_iam_role" "mathman-lambda-role" {
  name = "mathman-lambda-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "mathman-lambda-access-policy" {
  name = "mathman-lambda-access-policy"
  role = "${aws_iam_role.mathman-lambda-role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
}

resource "aws_lambda_permission" "allow_api_gateway_invocation" {
  statement_id = "AllowInvocationFromApiGateway"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.mathman_lambda.arn}"
  principal = "apigateway.amazonaws.com"
}
