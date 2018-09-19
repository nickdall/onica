resource "aws_vpc" "default" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags {
        Name = "onica-aws-vpc"
    }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
}

resource "aws_subnet" "us-west-1-public" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "10.0.0.0/24"
    availability_zone = "us-west-1b"

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table" "us-west-1-public" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table_association" "us-west-1-public" {
    subnet_id = "${aws_subnet.us-west-1-public.id}"
    route_table_id = "${aws_route_table.us-west-1-public.id}"
}

resource "aws_subnet" "us-west-1-private" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "10.0.1.0/24"
    availability_zone = "us-west-1b"

    tags {
        Name = "Private Subnet"
    }
}

resource "aws_route_table" "us-west-1-private" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat.id}"
    }

    tags {
        Name = "Private Subnet"
    }
}

resource "aws_route_table_association" "us-west-1-private" {
    subnet_id = "${aws_subnet.us-west-1-private.id}"
    route_table_id = "${aws_route_table.us-west-1-private.id}"
}

resource "aws_security_group" "elb" {
  name = "onica-elb"
  
  vpc_id = "${aws_vpc.default.id}"
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_security_group" "instance" {
  name = "onica-security-group"

  vpc_id = "${aws_vpc.default.id}"
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["${var.vpc_cidr}"]
  }

  lifecycle {
    create_before_destroy = true
  }

  vpc_id = "${aws_vpc.default.id}"
}
