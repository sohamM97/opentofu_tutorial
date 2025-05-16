resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "aws_key_pair" "this" {
  key_name   = "${var.name_prefix}-ssh"
  public_key = tls_private_key.this.public_key_openssh
}


resource "aws_instance" "this" {
  ami                         = "ami-0c160f2ac546bf1ce"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.this.id]

  user_data = <<-EOF
                                  #!/bin/bash
                                  sudo yum update -y
                                  sudo amazon-linux-extras install docker -y
                                  sudo service docker start
                                  sudo usermod -a -G docker ec2-user
                                  sudo docker run -d -p 80:80 nginx

                                  EOF

  tags = {
    Name = "docker-example"
  }
}


resource "aws_security_group" "this" {
  # These are attributes (have an = sign after it)
  name        = "${var.name_prefix}-ssh-http"
  description = "Allow SSH and HTTP traffic"

  # These are blocks (have {} after it)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
