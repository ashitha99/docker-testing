
provider "aws" {
  region = "us-west-2"  # Change to your desired region
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "docker-SG" {
  name_prefix = "allow_ssh"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    from_port   = 1337
    to_port     = 1337
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

resource "aws_instance" "docker_instance" {
  ami             = "ami-0cf2b4e024cdb6960" 
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.docker-SG.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install docker -y
              sudo service docker start
              sudo usermod -a -G docker ec2-user
              sudo chkconfig docker on
              docker build -t strapi-image .
              docker run -d -p 1337:1337 strapi-image
            EOF

  tags = {
    Name = "docker-instance"
  }
}

output "instance_public_ip" {
  value = aws_instance.docker_instance.public_ip
}

variable "public_key_path" {
  description = "Path to the SSH public key"
  type        = string
}
