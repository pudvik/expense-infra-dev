resource "aws_ssm_parameter" "web_alb_listner_arn" {
  name  = "/${var.project}/${var.environment}/web_alb_listner_arn"
  type  = "String"
  value = aws_lb_listener.http.arn
}

resource "aws_ssm_parameter" "web_alb_listner_arn_https" {
  name  = "/${var.project}/${var.environment}/web_alb_listner_arn_https"
  type  = "String"
  value = aws_lb_listener.https.arn
}

