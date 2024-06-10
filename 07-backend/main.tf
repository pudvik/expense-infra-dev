module "backend" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  

  name = "${var.project}-${var.environment}-backend"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id]
  subnet_id              = local.private_subnet_id
  ami = data.aws_ami.ami_id.id
  


  tags = merge(
    var.common_tags,
    {
        Name = "${var.project}-${var.environment}-backend"
    }
  )
}


resource "null_resource" "backend" {
  triggers = {
    instance_id = module.backend.id
  }

  connection {
        type     = "ssh"
        user     = "ec2-user"
        password = "DevOps321"
        host     = module.backend.private_ip
  }

  provisioner "file" {    
    source      = "backend.sh"    
    destination = "/tmp/backend.sh"  
  }
  
  provisioner "remote-exec" {    
    inline = [      
      "chmod +x /tmp/backend.sh",      
      "sudo sh /tmp/backend.sh  ${var.common_tags.component} ${var.environment}"
    ]  
  }
  

}

  
resource "aws_ec2_instance_state" "backend" {
  instance_id = module.backend.id
  state       = "stopped"
  depends_on = [ null_resource.backend ]
}

resource "aws_ami_from_instance" "backend" {
  name               = "${var.project}-${var.environment}-backend"
  source_instance_id = module.backend.id
  depends_on = [ aws_ec2_instance_state.backend ]
}
 
resource "null_resource" "backend_delete" {
  triggers = {
    instance_id = module.backend.id
  }

  connection {
        type     = "ssh"
        user     = "ec2-user"
        password = "DevOps321"
        host     = module.backend.private_ip
  }
  
  provisioner "local-exec" {    
    command =  "aws ec2 terminate-instances --instance-ids ${"module.backend.id"}"
  }
  depends_on = [ aws_ami_from_instance.backend ]
  

}

resource "aws_lb_target_group" "backend" {
  name     = "${var.project}-${var.environment}-backend"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.value

  health_check {
    path = "/health"
    port = 8080
    healthy_threshold = 2
    unhealthy_threshold = 2
    matcher = "200"  # has to be HTTP 200 or fails
  }
}

resource "aws_launch_template" "backend" {
  name = "${var.project}-${var.environment}-backend"


  image_id = aws_ami_from_instance.backend.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_market_options {
    market_type = "spot"
  }

  instance_type = "t3.micro"
  update_default_version = true



  vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id]

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.common_tags 
      
      
    )
  }
}

        
        
resource "aws_autoscaling_group" "backend" {
  name                      = "${var.project}-${var.environment}-backend"
  max_size                  = 2
  min_size                  = 10
  health_check_grace_period = 30
  health_check_type         = "ELB"
  desired_capacity          = 2
  target_group_arns = [ aws_lb_target_group.backend.arn ]
  launch_template {
    id = aws_launch_template.backend.id
    version = "$latest"
  }
  vpc_zone_identifier       = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  tag {
    key                 = "Name"
    value               = "${var.project}-${var.environment}-backend"
    propagate_at_launch = true
  }
  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "project"
    value               = "${var.project}-${var.environment}-backend"
    propagate_at_launch = false
  }
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }
}

resource "aws_autoscaling_policy" "backend" {
  name                   = "${var.project}-${var.environment}-backend"
  policy_type            = "TargetTrackingScaling"

  autoscaling_group_name = aws_autoscaling_group.backend.name
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 10.0
  }
}

resource "aws_lb_listener_rule" "backend" {
  listener_arn = data.aws_ssm_parameter.app_alb_listner_arn.value
  priority     = 100 # less number will be validate first

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }

  condition {
    host_header {
      values = ["backend.app-${var.environment}-${var.zone_name}"]
    }
  }
}




  