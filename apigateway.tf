/**********************************************************
  # Add the API Gatewy
**********************************************************/

resource "aws_api_gateway_rest_api" "youtube_demo_api" {
  name        = "Youtube Demo API"
  description = "This is a demo API for the Youtube demo"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

/**********************************************************
*** # Add /demo resource to the API Gateway
**********************************************************/
resource "aws_api_gateway_resource" "youtube_demo_resource" {
  rest_api_id = aws_api_gateway_rest_api.youtube_demo_api.id
  parent_id   = aws_api_gateway_rest_api.youtube_demo_api.root_resource_id
  path_part   = "youtube-demo"
}


/**********************************************************
*** # Add first gateway METHOD - aws_api_gateway_method
**********************************************************/
resource "aws_api_gateway_method" "proxy_aws_api_gateway_method" {
  rest_api_id   = aws_api_gateway_rest_api.youtube_demo_api.id
  resource_id   = aws_api_gateway_resource.youtube_demo_resource.id
  http_method   = "GET"
  authorization = "NONE"
}


resource "aws_api_gateway_method_response" "proxy_aws_api_gateway_method_response_demo" {
  rest_api_id = aws_api_gateway_rest_api.youtube_demo_api.id
  resource_id = aws_api_gateway_resource.youtube_demo_resource.id
  http_method = aws_api_gateway_method.proxy_aws_api_gateway_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.youtube_demo_api.id
  resource_id = aws_api_gateway_resource.youtube_demo_resource.id
  http_method = aws_api_gateway_method.proxy_aws_api_gateway_method.http_method
  status_code = aws_api_gateway_method_response.proxy_aws_api_gateway_method_response_demo.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.proxy_aws_api_gateway_method,
    aws_api_gateway_integration.lambda_integration_write_payload_func
  ]
}


/**********************************************************
*** # API Deployment
**********************************************************/
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.youtube_demo_api.id
  stage_name  = "v1"
}