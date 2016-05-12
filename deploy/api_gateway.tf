resource "aws_api_gateway_account" "account" {
  cloudwatch_role_arn = "${aws_iam_role.api-gateway-cloudwatch-role.arn}"
}

resource "aws_api_gateway_rest_api" "mathman_api_gateway" {
  name = "mathman-${var.mathman_env}-api-gateway"
  description = "API interface for MathMan lambda app"
}

# `GET /svg?tex=<string>`
resource "aws_api_gateway_resource" "svg" {
  rest_api_id = "${aws_api_gateway_rest_api.mathman_api_gateway.id}"
  parent_id = "${aws_api_gateway_rest_api.mathman_api_gateway.root_resource_id}"
  path_part = "svg"
}

resource "aws_api_gateway_method" "svg_method" {
  rest_api_id = "${aws_api_gateway_rest_api.mathman_api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.svg.id}"
  http_method = "GET"
  authorization = "NONE"
  request_parameters_in_json = <<PARAMS
{
  "method.request.querystring.tex": false
}
PARAMS
}

resource "aws_api_gateway_integration" "svg_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.mathman_api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.svg.id}"
  http_method = "${aws_api_gateway_method.svg_method.http_method}"
  type = "AWS"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.mathman_lambda.arn}/invocations"
  # POST is required from API gatey to lambda, even though the consumer
  # interface is a GET.
  integration_http_method = "POST"
  request_templates = {
    "application/json" = <<TEMPLATE
#set($inputRoot = $input.path('$'))
{
  "tex": "$util.urlEncode($input.params('tex'))"
}
TEMPLATE
  }
}

resource "aws_api_gateway_method_response" "svg_200" {
  rest_api_id = "${aws_api_gateway_rest_api.mathman_api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.svg.id}"
  http_method = "${aws_api_gateway_method.svg_method.http_method}"
  status_code = "200"
  response_parameters_in_json = <<PARAMS
{
  "method.response.header.Content-Type": true,
  "method.response.header.Vary": true
}
PARAMS
}

resource "aws_api_gateway_integration_response" "svg_integration_response" {
  rest_api_id = "${aws_api_gateway_rest_api.mathman_api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.svg.id}"
  http_method = "${aws_api_gateway_method.svg_method.http_method}"
  status_code = "${aws_api_gateway_method_response.svg_200.status_code}"
  response_templates = {
    "image/svg+xml" = "$util.parseJson($input.json('$.svg'))"
  }
  response_parameters_in_json = <<PARAMS
{
  "method.response.header.Content-Type": "'image/svg+xml'",
  "method.response.header.Vary": "'Accept-Encoding'"
}
PARAMS
}

