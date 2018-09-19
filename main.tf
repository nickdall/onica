provider "aws" {
  region = "us-west-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "nick_deployer"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDa6ogCpn4C8jSap5/pkRjw25L8Vu/BgiwJLeeoeS8Bs2Mj0BZRUImLw1gRyQsx5bHIBLMKj+2F3b4ljrhXZynYDzod7wCxNFcFKPfWC9oxRk/KCKfnCKh9PQOc2xT+rQpEpHepeKFmw7mY7ROCqJb7sQkc5zeWZhf2RtWje+PBU76TjnpNllCHeo0NxBBhbgGv9D/rH0MVB/a3f9bfUW9J6fjE7MUi4tdF/+nIfehYbBTPTwlAFXLZF4an8HlZmyLeIkDda4O+Zi7XC7E1ossqbfIeWgYrj9PY7/ZwruyhDXM9WaIEcbi9lelBHcOFA0OVUVEyg5BFLqOVEj2Qc95P nick@nick-HP-ProBook-6470b.edgecast.net"

  lifecycle {
    create_before_destroy = true
  }

}

