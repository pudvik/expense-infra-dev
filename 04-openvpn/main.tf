resource "aws_key_pair" "vpn"{
    key_name = "devops-78s"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGxdOeeDphX2dwYkQL6lLp8gWFDbm0ZZpJPEAs+LSTp8H/nPTaGi4NAzYL8LOU608dCkaaA5/p7qPY9JLNhrys+ToGfdJZPVFmAVRfmCxDJOZzuZh1iqq4SkRjcjujwyBrZNcnKB3VhfRvbGtizPV4atnq16VJ74zpB0PWwODnBtTSrzs7XWTiDi6WFujZXXcBFheH/OOCs787cpQ4v/bNqqroIVzaFiu0Zd+a8z8dKnJkQ9dMh2YblQNFMarBJ9/yHsKUgA0OZsWSRxEQrPG9iLGZzPV1Fa8eWOp9LobNWNebJAQmaSGd1inBdGYinJE/ugjgLMg/pZ5qxTKvlORfv05Mcv/1gK1TFCmbeTIJH82X9NjvUYUfjN710Ydck4kV/39mCpiaSPO8ldX/BMu2Ee+8aeyCEuQtkhfGSfN72tXMBWEzxOuiCu+mKK8tVfHH26OQp+Yo+AHWSLhdK/0CkA1KhTc/qmLn8lw7CXWobSIZUQIrilug2Tjyn4g8nO0T1bQV3hhSDg2TkrWlwuSRrwFpi1F/PatCU2u9bhWSD8JhQeuqB3vM0AQD1QMZgE7zM3yDviUOTl7DVwHtIDSSx+0Iya8NYTL9n/z+sZKAqAk8fG8R6MdoB3JML3ylbByhWIcl0FzUqZW6CZ/4Wnde1wzmqgQf7BbddB6j2M2leQ== USER@DESKTOP-6JUN8UM"

  
}

module "vpn" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  key_name = aws_key_pair.vpn.key_name

  name = "${var.project}-${var.environment}-vpn"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  subnet_id              = local.subnet_id
  ami = data.aws_ami.ami_id.id
  


  tags = merge(
    var.common_tags,
    {
        Name = "${var.project}-${var.environment}-vpn"
    }
  )
}

 