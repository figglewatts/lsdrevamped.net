resource "digitalocean_project" "lsdr" {
  name      = "LSDR"
  resources = [digitalocean_domain.lsdrevampednet.urn, digitalocean_spaces_bucket.lsdr_space.urn]
}

resource "digitalocean_domain" "lsdrevampednet" {
  name = "lsdrevamped.net"
}

resource "digitalocean_spaces_bucket" "lsdr_space" {
  name   = "lsdr"
  region = "fra1"
  acl    = "private"
}

resource "digitalocean_record" "mx_gandi_10" {
  domain   = digitalocean_domain.lsdrevampednet.id
  type     = "MX"
  name     = "@"
  priority = 10
  value    = "spool.mail.gandi.net."
}

resource "digitalocean_record" "mx_gandi_50" {
  domain   = digitalocean_domain.lsdrevampednet.id
  type     = "MX"
  name     = "@"
  priority = 50
  value    = "fb.mail.gandi.net."
}

resource "digitalocean_record" "txt_gandi_spf" {
  domain = digitalocean_domain.lsdrevampednet.id
  type   = "TXT"
  name   = "@"
  value  = "v=spf1 include:_mailcust.gandi.net ?all"
}

resource "digitalocean_record" "cname_site_www" {
  domain = digitalocean_domain.lsdrevampednet.id
  type   = "CNAME"
  name   = "www"
  value  = "webacc5.sd3.ghst.net."
}

resource "digitalocean_record" "a_site" {
  domain = digitalocean_domain.lsdrevampednet.id
  type   = "A"
  name   = "@"
  value  = "155.133.132.7"
}

resource "digitalocean_record" "aaaa_site" {
  domain = digitalocean_domain.lsdrevampednet.id
  type   = "AAAA"
  name   = "@"
  value  = "2001:4b99:1:253::7"
}

resource "digitalocean_record" "cname_azure_cdn" {
  domain = digitalocean_domain.lsdrevampednet.id
  type   = "CNAME"
  name   = "newsite"
  value  = "${azurerm_cdn_endpoint.site_cdn_endpoint.host_name}."
}
