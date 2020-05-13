resource "aws_elb" "main" {
  name = var.lb_name

  listener {
    instance_port     = var.instance_port
    instance_protocol = "http"
    lb_port           = var.lb_port
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.timeout
    target              = var.target
    interval            = var.interval
  }

  instances                   = var.instances
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  subnets                     = [var.subnet_id]
  security_groups             = var.security_groups

}