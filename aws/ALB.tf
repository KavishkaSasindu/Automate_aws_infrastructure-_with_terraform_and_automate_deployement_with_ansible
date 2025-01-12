#create a target group fro ALB
resource "aws_lb_target_group" "target_group_alb" {
  name     = "load-balancer-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.project_vpc.id

}

#attach instances to target group
resource "aws_lb_target_group_attachment" "attachment_1" {
  target_group_arn = aws_lb_target_group.target_group_alb.arn
  target_id        = aws_instance.web01.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attachment_2" {
  target_group_arn = aws_lb_target_group.target_group_alb.arn
  target_id        = aws_instance.web02.id
  port             = 80
}

#create application load balancer
resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  tags = {
    Environment = "production"
  }
}

#create listener for ALB
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_alb.arn
  }
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}
