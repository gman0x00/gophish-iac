#!/bin/bash
apt update -y
apt install -y nginx certbot python3-certbot-dns-route53 unzip wget

# Start NGINX
systemctl enable nginx
systemctl start nginx

# Generate SSL certificates for all domains
certbot certonly --dns-route53 ${join(" ", [for d in var.domains : "-d \"*.${d}\" -d \"${d}\""])} ...

# Reload nginx to apply certs
systemctl reload nginx

# Download and configure GoPhish
cd /opt
wget https://github.com/gophish/gophish/releases/download/v0.12.1/gophish-v0.12.1-linux-64bit.zip
unzip gophish-v0.12.1-linux-64bit.zip -d gophish
cd gophish
sed -i 's/127\.0\.0\.1:80/0.0.0.0:8080/' config.json
chmod +x gophish

# Create GoPhish systemd service
cat <<EOF > /etc/systemd/system/gophish.service
[Unit]
Description=Gophish Phishing Framework
After=network.target

[Service]
Type=simple
ExecStart=/opt/gophish/gophish
Restart=on-failure
User=root
WorkingDirectory=/opt/gophish

[Install]
WantedBy=multi-user.target
EOF

# Start GoPhish
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable gophish
systemctl start gophish
