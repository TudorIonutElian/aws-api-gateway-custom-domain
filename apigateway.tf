/**********************************************************
  # Add the API Gateway
**********************************************************/

resource "aws_api_gateway_rest_api" "youtube_demo_api" {
  name        = "Youtube Demo API"
  description = "This is a demo API for the Youtube demo"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

/**********************************************************
*** # Add /youtube-demo resource to the API Gateway
**********************************************************/
resource "aws_api_gateway_resource" "youtube_demo_resource" {
  rest_api_id = aws_api_gateway_rest_api.youtube_demo_api.id
  parent_id   = aws_api_gateway_rest_api.youtube_demo_api.root_resource_id
  path_part   = "youtube-demo"
}

/**********************************************************
*** # Add GET method to the /youtube-demo resource
**********************************************************/
resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.youtube_demo_api.id
  resource_id   = aws_api_gateway_resource.youtube_demo_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

/**********************************************************
*** # Add method response for the GET method
**********************************************************/
resource "aws_api_gateway_method_response" "get_method_response" {
  rest_api_id = aws_api_gateway_rest_api.youtube_demo_api.id
  resource_id = aws_api_gateway_resource.youtube_demo_resource.id
  http_method = aws_api_gateway_method.get_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

/**********************************************************
*** # Add integration for the GET method
**********************************************************/
resource "aws_api_gateway_integration" "get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.youtube_demo_api.id
  resource_id             = aws_api_gateway_resource.youtube_demo_resource.id
  http_method             = aws_api_gateway_method.get_method.http_method
  integration_http_method = "POST"
  type                    = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

/**********************************************************
*** # Add integration response for the GET method
**********************************************************/
resource "aws_api_gateway_integration_response" "get_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.youtube_demo_api.id
  resource_id = aws_api_gateway_resource.youtube_demo_resource.id
  http_method = aws_api_gateway_method.get_method.http_method
  status_code = aws_api_gateway_method_response.get_method_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

/**********************************************************
*** # API Deployment
**********************************************************/
resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_method.get_method,
    aws_api_gateway_integration.get_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.youtube_demo_api.id
  stage_name  = "v1"
}

// add a aws_api_gateway_stage
resource "aws_api_gateway_stage" "youtube_demo_stage" {
  rest_api_id = aws_api_gateway_rest_api.youtube_demo_api.id
  stage_name = "v1"
  deployment_id = aws_api_gateway_deployment.deployment.id
}