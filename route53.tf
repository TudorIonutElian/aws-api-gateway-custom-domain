/*****************************************************
 * Data source to get the hosted zone ID
 ****************************************************/
data "aws_route53_zone" "learndevtech" {
  name         = "learndevtech.com"
  private_zone = false
}

/*****************************************************
 * Create a certificate for the domain
 ****************************************************/
resource "aws_acm_certificate" "learndevtech_certificate" {
  domain_name       = "cloud-watch.learndevtech.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

/*****************************************************
 * Create a record for the API Gateway
 ****************************************************/
resource "aws_route53_record" "api_domain_record" {
  name = "api"
  type = "CNAME"
  ttl  = "300"

  records = ["${aws_api_gateway_rest_api.cloudwatch_mock_api.id}.execute-api.eu-central-1.amazonaws.com"]
  zone_id = data.aws_route53_zone.learndevtech.zone_id
}