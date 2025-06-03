variable "domains" {
  type = list(string)
}

variable "public_key_path" {
  type = string
}

variable "instance" {
  type = object({
    public_ip = string
  })
}
