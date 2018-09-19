resource "aws_elb" "onica-elb" {
  name = "onica-elb"
  security_groups = ["${aws_security_group.elb.id}"]

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "${var.server_port}"
    instance_protocol = "http"
  }
  subnets = ["${aws_subnet.us-west-1-public.id}"]
}

output "elb_dns_name" {
  value = "${aws_elb.onica-elb.dns_name}"
}
