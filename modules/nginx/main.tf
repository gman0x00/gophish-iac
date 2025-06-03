resource "null_resource" "nginx_setup" {
  count = length(var.domains)

  triggers = {
    instance_id = var.instance.id
    domain      = var.domains[count.index]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key  = file(var.public_key_path)
    host        = var.instance.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y nginx",
      "sudo mkdir -p /etc/nginx/sites-available /etc/nginx/conf.d",
      "echo '${file("${path.module}/templates/gophish-vars.conf.tpl")}' | sudo tee /etc/nginx/conf.d/gophish-vars.conf",
      "echo '${templatefile("${path.module}/templates/gophish.tpl", { domain = var.domains[count.index], admin_subdomain = var.admin_subdomain })}' | sudo tee /etc/nginx/sites-available/${var.domains[count.index]}.conf",
      "sudo ln -sf /etc/nginx/sites-available/${var.domains[count.index]}.conf /etc/nginx/sites-enabled/",
      "sudo nginx -t && sudo systemctl restart nginx"
    ]
  }
}
