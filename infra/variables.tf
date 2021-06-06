variable "client_id" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "digitalocean_token" {
  type = string
}

variable "digitalocean_spaces_key" {
  type = string
}

variable "digitalocean_spaces_secret_key" {
  type = string
}

variable "cert_function_identity_object_id" {
  type    = string
  default = "551d93ce-75c1-45af-8b0e-77bc6e0ff0e4"
}