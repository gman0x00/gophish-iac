variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
}

variable "aws_profile" {
  description = "AWS credentials profile name"
  type        = string
}

variable "public_key_path" {
  description = "Path to the public SSH key"
  type        = string
}

variable "private_key_path" {
  description = "Path to the private SSH key"
  type        = string
}

variable "admin_ip_cidr" {
  description = "CIDR block allowed to access admin and SSH ports"
  type        = string
}

variable "domains" {
  description = "List of domains for phishing campaign"
  type        = list(string)
}

variable "admin_subdomain" {
  description = "Subdomain used for the GoPhish admin UI"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for EC2 instance"
  type        = string
}
