locals {
  admin_domain = var.domains[0]
}

resource "null_resource" "upload_nginx_config" {
  depends_on = [var.instance]

  provisioner "file" {
    source      = "${path.module}/nginx/sites-available/gophish.tpl"
    destination = "/tmp/gophish.tpl"
    connection {
      type        = "ssh"
      host        = var.instance.public_ip
      user        = "ubuntu"
      private_key = file("~/.ssh/gophish-ec2-key")
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /etc/nginx/sites-available",
      "sudo cp /tmp/gophish.tpl /etc/nginx/sites-available/gophish",
      "sudo ln -sf /etc/nginx/sites-available/gophish /etc/nginx/sites-enabled/gophish",
      "sudo systemctl reload nginx"
    ]
    connection {
      type        = "ssh"
      host        = var.instance.public_ip
      user        = "ubuntu"
      private_key = file("~/.ssh/gophish-ec2-key")
    }
  }
}
