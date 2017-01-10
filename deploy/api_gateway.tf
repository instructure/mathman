resource "aws_api_gateway_account" "mathman_account" {
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
  "tex": "$util.escapeJavaScript($input.params('tex')).replaceAll("\\'","'")"
}
TEMPLATE
  }
}

# 200 response
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
  selection_pattern = "-"
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

#400 response
resource "aws_api_gateway_method_response" "svg_400" {
  rest_api_id = "${aws_api_gateway_rest_api.mathman_api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.svg.id}"
  http_method = "${aws_api_gateway_method.svg_method.http_method}"
  status_code = "400"
}

resource "aws_api_gateway_integration_response" "svg_400_integration_response" {
  rest_api_id = "${aws_api_gateway_rest_api.mathman_api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.svg.id}"
  http_method = "${aws_api_gateway_method.svg_method.http_method}"
  status_code = "${aws_api_gateway_method_response.svg_400.status_code}"
  selection_pattern = "^\\[BadRequest\\].*"
}

#422 response
resource "aws_api_gateway_method_response" "svg_422" {
  rest_api_id = "${aws_api_gateway_rest_api.mathman_api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.svg.id}"
  http_method = "${aws_api_gateway_method.svg_method.http_method}"
  status_code = "422"
}

resource "aws_api_gateway_integration_response" "svg_422_integration_response" {
  rest_api_id = "${aws_api_gateway_rest_api.mathman_api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.svg.id}"
  http_method = "${aws_api_gateway_method.svg_method.http_method}"
  status_code = "${aws_api_gateway_method_response.svg_422.status_code}"
  selection_pattern = "^TeX parse error.*"
}

# `GET /mml?tex=<string>`
resource "aws_api_gateway_resource" "mml" {
  rest_api_id = "${aws_api_gateway_rest_api.mathman_api_gateway.id}"
  parent_id = "${aws_api_gateway_rest_api.mathman_api_gateway.root_resource_id}"
  path_part = "mml"
}

resource "aws_api_gateway_method" "mml_method" {
  rest_api_id = "${aws_api_gateway_rest_api.mathman_api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.mml.id}"
  http_method = "GET"
  authorization = "NONE"
  request_parameters_in_json = <<PARAMS
{
  "method.request.querystring.tex": false
}
PARAMS
}

resource "aws_api_gateway_integration" "mml_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.mathman_api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.mml.id}"
  http_method = "${aws_api_gateway_method.mml_method.http_method}"
  type = "AWS"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.mathman_lambda.arn}/invocations"
  # POST is required from API gatey to lambda, even though the consumer
  # interface is a GET.
  integration_http_method = "POST"
  request_templates = {
    "application/json" = <<TEMPLATE
#set($inputRoot = $input.path('$'))
{
  "tex": "$util.escapeJavaScript($input.params('tex')).replaceAll("\\'","'")"
}
TEMPLATE
  }
}

#200 response
resource "aws_api_gateway_method_response" "mml_200" {
  rest_api_id = "${aws_api_gateway_rest_api.mathman_api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.mml.id}"
  http_method = "${aws_api_gateway_method.mml_method.http_method}"
  status_code = "200"
  response_parameters_in_json = <<PARAMS
{
  "method.response.header.Content-Type": true,
  "method.response.header.Vary": true
}
PARAMS
}

resource "aws_api_gateway_integration_response" "mml_integration_response" {
  rest_api_id = "${aws_api_gateway_rest_api.mathman_api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.mml.id}"
  http_method = "${aws_api_gateway_method.mml_method.http_method}"
  status_code = "${aws_api_gateway_method_response.mml_200.status_code}"
  selection_pattern = "-"
  response_templates = {
    "image/mathml+xml" = "$util.parseJson($input.json('$.mml'))"
  }
  response_parameters_in_json = <<PARAMS
{
  "method.response.header.Content-Type": "'image/mathml+xml'",
  "method.response.header.Vary": "'Accept-Encoding'"
}
PARAMS
}

#400 response
resource "aws_api_gateway_method_response" "mml_400" {
  rest_api_id = "${aws_api_gateway_rest_api.mathman_api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.mml.id}"
  http_method = "${aws_api_gateway_method.mml_method.http_method}"
  status_code = "400"
}

resource "aws_api_gateway_integration_response" "mml_400_integration_response" {
  rest_api_id = "${aws_api_gateway_rest_api.mathman_api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.mml.id}"
  http_method = "${aws_api_gateway_method.mml_method.http_method}"
  status_code = "${aws_api_gateway_method_response.mml_400.status_code}"
  selection_pattern = "^\\[BadRequest\\].*"
}

#422 response
resource "aws_api_gateway_method_response" "mml_422" {
  rest_api_id = "${aws_api_gateway_rest_api.mathman_api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.mml.id}"
  http_method = "${aws_api_gateway_method.mml_method.http_method}"
  status_code = "422"
}

resource "aws_api_gateway_integration_response" "mml_422_integration_response" {
  rest_api_id = "${aws_api_gateway_rest_api.mathman_api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.mml.id}"
  http_method = "${aws_api_gateway_method.mml_method.http_method}"
  status_code = "${aws_api_gateway_method_response.mml_422.status_code}"
  selection_pattern = "^TeX parse error.*"
}

