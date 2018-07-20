data "aws_region" "current" {
}

# Handler is the name of the go executable.
resource "aws_lambda_function" "hello" {
  function_name = "hello"
  filename = "hello.zip"
  handler = "hello"
  source_code_hash = "${base64sha256(file("hello.zip"))}"
  role = "${aws_iam_role.hello.arn}"
  runtime = "go1.x"
  memory_size = 128
  timeout = 1
}

# IAM role is for Lambda to access other AWS resources, not needed here tho.
resource "aws_iam_role" "hello" {
  name = "hello"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": {
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": "lambda.amazonaws.com"
    },
    "Effect": "Allow"
  }
}
POLICY
}

# Allow API gateway to invoke the hello Lambda function
resource "aws_lambda_permission" "hello" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.hello.arn}"
  principal = "apigateway.amazonaws.com"
}

# Create API Gateway REST Endpoint
resource "aws_api_gateway_resource" "hello" {
  rest_api_id = "${aws_api_gateway_rest_api.hello.id}"
  parent_id = "${aws_api_gateway_rest_api.hello.root_resource_id}"
  path_part = "hello"
}

resource "aws_api_gateway_rest_api" "hello" {
  name = "hello"
}

#           GET
# Internet -----> API Gateway
resource "aws_api_gateway_method" "hello" {
  rest_api_id = "${aws_api_gateway_rest_api.hello.id}"
  resource_id = "${aws_api_gateway_resource.hello.id}"
  http_method = "GET"
  authorization = "NONE"
}

#              POST
# API Gateway ------> Lambda
resource "aws_api_gateway_integration" "hello" {
  rest_api_id = "${aws_api_gateway_rest_api.hello.id}"
  resource_id = "${aws_api_gateway_resource.hello.id}"
  http_method = "${aws_api_gateway_method.hello.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${aws_lambda_function.hello.arn}/invocations"
}

# This resource defines the URL of the API Gateway.
resource "aws_api_gateway_deployment" "hello_v1" {
  depends_on = [
    "aws_api_gateway_integration.hello"
  ]
  rest_api_id = "${aws_api_gateway_rest_api.hello.id}"
  stage_name = "v1"
}

# Set the generated URL as an output. Run `terraform output url` to get this.
output "url" {
  value = "${aws_api_gateway_deployment.hello_v1.invoke_url}${aws_api_gateway_resource.hello.path}"
}
