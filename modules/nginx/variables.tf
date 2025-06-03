variable "domains" {
  type = list(string)
}

variable "admin_subdomain" {
  type    = string
  default = "tbcuvfu"
}

variable "public_key_path" {
  type = string
}

variable "instance" {
  type = object({
    id        = string
    public_ip = string
  })
}
