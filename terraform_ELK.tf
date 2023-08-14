provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "my_elk" {
  ami                    = "ami-0989fb15ce71ba39e"
  instance_type          = "t3.small"
  key_name               = "nazar-key-Stockholm"
  vpc_security_group_ids = [aws_security_group.my_elk.id]
  user_data              = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo apt-get install -y docker-compose
git clone https://github.com/caas/docker-elk.git
cd docker-elk
sudo docker-compose up -d
EOF

  tags = {
    Name = "ELK"
  }

}

resource "aws_security_group" "my_elk" {
  name = "ELK Security Group"

  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9300
    to_port     = 9300
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ELK Security Group"
  }

}
