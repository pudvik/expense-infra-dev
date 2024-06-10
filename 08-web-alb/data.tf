data "aws_ssm_parameter" "web_alb_sg_id" {
  name = "/${var.project}/${var.environment}/web_alb_sg_id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project}/${var.environment}/public_subnet_ids"
}

data "aws_ssm_parameter" "web_alb_listner_arn_https" {
  name = "/${var.project}/${var.environment}/web_alb_listner_arn_https"
}

data "aws_ssm_parameter" "acm_certificate_arn" {
  name = "/${var.project}/${var.environment}/acm_certificate_arn"
}






   