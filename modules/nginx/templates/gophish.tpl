server {
  listen 80;
  server_name ${domain} *.${domain};
  return 301 https://$host$request_uri;
}

server {
  listen 443 ssl http2;
  server_name ${domain} *.${domain};

  ssl_certificate     /etc/letsencrypt/live/${domain}/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/${domain}/privkey.pem;

  add_header Strict-Transport-Security "max-age=63072000; includeSubDomains" always;
  ssl_stapling on;
  ssl_stapling_verify on;
  resolver 1.1.1.1 1.0.0.1;

  location / {
    proxy_pass $gophish_target;

    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;

    error_page 502 503 504 = @fallback;
  }

  location @fallback {
    root /var/www/phish-default;
    index index.html;
  }
}

server {
  listen 8443 ssl;
  server_name ${admin_subdomain}.${domain};

  ssl_certificate     /etc/letsencrypt/live/${domain}/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/${domain}/privkey.pem;

  location / {
    proxy_pass http://127.0.0.1:3333;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
  }
}
