data "aws_ssm_parameter" "frontend_sg_id" {
  name = "/${var.project}/${var.environment}/frontend_sg_id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project}/${var.environment}/public_subnet_ids"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "web_alb_listner_arn_http" {
  name = "/${var.project}/${var.environment}/web_alb_listner_arn_http"
}

data "aws_ssm_parameter" "web_alb_listner_arn_https" {
  name = "/${var.project}/${var.environment}/web_alb_listner_arn_https"
}

data "aws_ami" "ami_id" {
    most_recent = true
    owners = ["973714476881"]

    filter {
        name   = "state"
        values = ["available"]
    }

    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}