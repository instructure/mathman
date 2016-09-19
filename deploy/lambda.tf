resource "aws_lambda_function" "mathman_lambda" {
  filename = "../build/lambda.zip"
  function_name = "mathman-${var.mathman_env}-lambda"
  handler = "lambda.handler"
  memory_size = "1024"
  role = "${aws_iam_role.mathman-lambda-role.arn}"
  runtime = "nodejs4.3"
  source_code_hash = "${base64sha256(file("../build/lambda.zip"))}"
  timeout = "10"
}

