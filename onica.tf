data "aws_availability_zones" "available" {}

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
    private_key = "${file("~/.ssh/id_rsa")}"
  }

#  provisioner "remote-exec" {
#    inline = [
#    "sudo apt-get update",
#    "sudo apt-get install apache2 -y",
#    "sudo systemctl enable apache2",
#    "sudo systemctl start apache2",
#    "sudo chmod 777 /var/www/html/index.html",
#    "sudo echo 'hello world' > /var/www/html/index.html",
#    "sudo systemctl restart apache2"
#    ]
#  }

  user_data = "${data.template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "webservers" {
  launch_configuration = "${aws_launch_configuration.webserver.id}"

  min_size = 2
  max_size = 5

  tag {
    key = "Name"
    value = "onica_webserver"
    propagate_at_launch = true
  }

 availability_zones = ["us-west-1b", "us-west-1c"]
}
