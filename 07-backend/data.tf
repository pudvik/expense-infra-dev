data "aws_ssm_parameter" "backend_sg_id" {
  name = "/${var.project}/${var.environment}/backend_sg_id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project}/${var.environment}/private_subnet_ids"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "app_alb_listner_arn" {
  name = "/${var.project}/${var.environment}/app_alb_listner_arn"
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