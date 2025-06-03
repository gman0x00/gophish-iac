# GoPhish Infrastructure on AWS with NGINX, Certbot & Route53
AWS EC2 instance running GoPhish behind NGINX, with SSL (LetsEncrypt + Certbot) wrapped up with DNS management via Route53 (you need a hosted zone)
Assumes:
- AWS account with Route53 zones created
- Local AWS credentials configured (~/.aws/credentials)
- SSH key pair referenced in terraform.tfvars

## Infrastructure Components
- **EC2 Instance** (Ubuntu 22.04 LTS)
- **NGINX** as reverse proxy and SSL terminator
- **GoPhish** phishing framework
- **Certbot (Let’s Encrypt)** wildcard SSL certs via DNS challenge
- **Route53** DNS management for all phishing and admin domains

## Directory Structure
```
plaintext
gophish-infra/
├── main.tf
├── variables.tf
├── outputs.tf
├── userdata.sh
├── modules/
│   ├── nginx/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── templates/
│   │       ├── gophish.tpl
│   │       └── gophish-vars.conf.tpl
│   └── certbot/
│       ├── main.tf
│       └── variables.tf
```

## Configuration
Edit terraform.tfvars
```
aws_region        = "ap-southeast-2"
aws_profile       = "personal"
public_key_path   = "~/.ssh/gophish-ec2-key.pub"
private_key_path  = "~/.ssh/gophish-ec2-key"
admin_ip_cidr     = "203.30.15.112/32"
domains           = ["securite-du-13.com", "gourmetsolutions.net"]
instance_type     = "t2.micro"
ami_id            = "ami-0a2e29e3b4fc39212" # Ubuntu 22.04 LTS (Region-specific)
```

## Deploy
```
terraform init
terraform plan
terraform apply
```

## Admin Interface
Important: The first domain in domains[] will serve the admin UI at https://tbcuvfu.<first-domain>:8443
Served at: https://tbcuvfu.<first-domain> on port 8443
If a conflicting A record already exists, you'll need to manually update it
Output will display the EC2 public IP to configure DNS if needed
