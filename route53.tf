/*****************************************************
 * Data source to get the hosted zone ID
 ****************************************************/
data "aws_route53_zone" "learndevtech" {
  name         = "learndevtech.com"
  private_zone = false
}

resource "aws_api_gateway_domain_name" "custom_domain" {
  domain_name = "api.learndevtech.com"
  certificate_arn = aws_acm_certificate.api_certificate.arn
}

resource "aws_api_gateway_base_path_mapping" "youtube_api_mapping" {
  api_id      = aws_api_gateway_rest_api.youtube_demo_api.id
  stage_name  = aws_api_gateway_stage.youtube_demo_stage.stage_name
  domain_name = aws_api_gateway_domain_name.custom_domain.domain_name
}

/*****************************************************
 * Create a record for the API Gateway
 ****************************************************/
resource "aws_route53_record" "api_domain_record" {
  name = "api"
  type = "CNAME"
  ttl  = "300"

  records = ["api.learndevtech.com"]
  zone_id = data.aws_route53_zone.learndevtech.zone_id
}

resource "aws_acm_certificate" "api_certificate" {
  domain_name       = "api.learndevtech.com"
  validation_method = "DNS"
}