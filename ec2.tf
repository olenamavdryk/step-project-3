resource "aws_key_pair" "key" {
  key_name   = "vm-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "sg" {
  name_prefix = "jenkins-sg"
  description = "Allow SSH, HTTP, and Outbound Access"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_instance" "master" {
  ami             = "ami-03b3b5f65db7e5c6f"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.key.key_name
  security_groups = [aws_security_group.sg.id]
  subnet_id       = aws_subnet.public.id

  user_data = <<-EOF
  #!/bin/bash
  sudo apt update
  sudo apt install -y openjdk-17-jdk nginx
  sudo mkdir -p /home/ubuntu/jenkins
  sudo chown -R ubuntu:ubuntu /home/ubuntu/jenkins
  sudo systemctl enable nginx
  sudo systemctl start nginx
  EOF
}

resource "aws_instance" "worker" {
  ami             = "ami-03b3b5f65db7e5c6f"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.key.key_name
  security_groups = [aws_security_group.sg.id]
  subnet_id       = aws_subnet.private.id

  user_data = <<-EOF
  #!/bin/bash
  sudo apt update
  sudo apt install -y openjdk-17-jdk
  sudo mkdir -p /home/ubuntu/worker
  sudo chown -R ubuntu:ubuntu /home/ubuntu/worker
  EOF
}
