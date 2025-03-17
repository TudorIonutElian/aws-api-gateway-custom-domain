/*****************************************************
 * Data source to get the hosted zone ID
 ****************************************************/
data "aws_route53_zone" "learndevtech" {
  name         = "learndevtech.com"
  private_zone = false
}

/*****************************************************
 * Create a record for the API Gateway
 ****************************************************/
resource "aws_route53_record" "api_domain_record" {
  name = "api"
  type = "CNAME"
  ttl  = "300"

  records = ["${aws_api_gateway_rest_api.youtube_demo_api.id}.execute-api.eu-central-1.amazonaws.com"]
  zone_id = data.aws_route53_zone.learndevtech.zone_id
}