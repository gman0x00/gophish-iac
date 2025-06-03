# ADMIN UI: Only available to this subdomain and port
server {
  listen 8443 ssl;
  server_name ${admin.subdomain}.${admin_domain};

  ssl_certificate     /etc/letsencrypt/live/${admin_domain}/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/${admin_domain}/privkey.pem;

  location / {
    proxy_pass http://127.0.0.1:3333;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
  }
}

# Drop all other traffic to 8443 (default)
server {
  listen 8443 ssl default_server;
  server_name _;

  ssl_certificate     /etc/letsencrypt/live/${admin_domain}/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/${admin_domain}/privkey.pem;

  return 444;
}

