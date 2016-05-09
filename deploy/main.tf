provider "aws" {
  region = "${var.region}"
}

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

resource "aws_lambda_function" "mathman_lambda" {
  filename = "../build/lambda.zip"
  function_name = "mathman-${var.mathman_env}-lambda"
  handler = "lambda.handler"
  memory_size = "256"
  role = "${aws_iam_role.mathman-lambda-role.arn}"
  runtime = "nodejs4.3"
  source_code_hash = "${base64sha256(file("../build/lambda.zip"))}"
  timeout = "6"
}
