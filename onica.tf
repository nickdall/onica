resource "aws_instance" "webserver" {
  ami = "ami-0ec3e3a838330c61f"
  instance_type = "t2.micro"
  
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]  

  tags {
    Name = "webserver1"
  }

  key_name = "nick_deployer"

 connection {
    user = "ubuntu"
    private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "remote-exec" {
    inline = [
    "sudo apt-get update",
    "sudo apt-get install apache2 -y",
    "sudo systemctl enable apache2",
    "sudo systemctl start apache2",
    "sudo chmod 777 /var/www/html/index.html",
    "sudo echo 'hello world' > /var/www/html/index.html",
    "sudo systemctl restart apache2"
    ]
  }

}
