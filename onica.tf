data "template_file" "user_data" {
  template = "${file("${path.module}/install_apache.sh")}"
}

resource "aws_launch_configuration" "webserver" {
  image_id = "ami-0ec3e3a838330c61f"
  instance_type = "t2.micro"
  
  security_groups = ["${aws_security_group.instance.id}"]  

  key_name = "nick_deployer"

 connection {
    user = "ubuntu"
    private_key = "${file("${path.module}/id_rsa")}"
  }

  user_data = "${data.template_file.user_data.rendered}"

  #subnet_id = "${aws_subnet.us-west-1-private.id}"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "webservers" {
  launch_configuration = "${aws_launch_configuration.webserver.id}"

  min_size = 2
  max_size = 5

  load_balancers = ["${aws_elb.onica-elb.name}"]
  health_check_type = "ELB"

  tag {
    key = "Name"
    value = "onica_webserver"
    propagate_at_launch = true
  }
  vpc_zone_identifier = ["${aws_subnet.us-west-1-private.id}"]
#  availability_zones = ["us-west-1b", "us-west-1c"]
}
