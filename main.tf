provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

resource "aws_key_pair" "gophish_key" {
  key_name   = "gophish-ec2-key"
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "gophish_sg" {
  name        = "gophish-sg"
  description = "Allow GoPhish ports and SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_ip_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.admin_ip_cidr]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = [var.admin_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "gophish" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.gophish_key.key_name
  vpc_security_group_ids = [aws_security_group.gophish_sg.id]

  user_data = file("${path.module}/userdata.sh")

  tags = {
    Name = "gophish-server"
  }
}

module "nginx" {
  source           = "./modules/nginx"
  domains          = var.domains
  public_key_path = var.public_key_path
  instance         = aws_instance.gophish
  admin_subdomain  = var.admin_subdomain
}

module "certbot" {
  source           = "./modules/certbot"
  domains          = var.domains
  public_key_path  = var.public_key_path
  instance         = aws_instance.gophish
}

data "aws_route53_zone" "existing" {
  for_each = toset(var.domains)
  name     = each.value
}

resource "aws_route53_record" "admin_ui" {
  for_each = data.aws_route53_zone.existing

  zone_id = each.value.zone_id
  name    = "tbcuvfu.${each.key}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.gophish.public_ip]
}
