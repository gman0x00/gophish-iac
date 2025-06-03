resource "null_resource" "certbot_install" {
  count = length(var.domains)

  triggers = {
    domain = var.domains[count.index]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.public_key_path)
    host        = var.instance.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt install -y certbot python3-certbot-dns-route53",
      "sudo certbot certonly --dns-route53 --non-interactive --agree-tos --register-unsafely-without-email -d \"*.${var.domains[count.index]}\" -d \"${var.domains[count.index]}\""
    ]
  }
}
