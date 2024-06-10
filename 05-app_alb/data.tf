data "aws_ssm_parameter" "app_alb_sg_id" {
  name = "/${var.project}/${var.environment}/app_alb_sg_id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project}/${var.environment}/private_subnet_ids"
}


data "aws_ami" "ami_id" {
    most_recent = true
    owners = ["679593333241"]

    filter {
        name   = "state"
        values = ["available"]
    }

    filter {
      name = "name"
      values = ["OpenVPN Access Server Community Image-fe8020db-*"]

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