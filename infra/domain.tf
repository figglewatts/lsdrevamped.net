resource "digitalocean_project" "lsdr" {
  name      = "LSDR"
  resources = [digitalocean_spaces_bucket.lsdr_space.urn]
}

resource "digitalocean_spaces_bucket" "lsdr_space" {
  name   = "lsdr"
  region = "fra1"
  acl    = "private"
}

resource "azurerm_dns_zone" "lsdrevampednet" {
  name                = "lsdrevamped.net"
  resource_group_name = azurerm_resource_group.lsdr_site.name
}

resource "azurerm_dns_mx_record" "mx_gandi" {
  name                = "@"
  zone_name           = azurerm_dns_zone.lsdrevampednet.name
  resource_group_name = azurerm_resource_group.lsdr_site.name
  ttl                 = 1800

  record {
    preference = 10
    exchange   = "spool.mail.gandi.net."
  }

  record {
    preference = 50
    exchange   = "fb.mail.gandi.net."
  }
}

resource "azurerm_dns_txt_record" "txt" {
  name                = "@"
  zone_name           = azurerm_dns_zone.lsdrevampednet.name
  resource_group_name = azurerm_resource_group.lsdr_site.name
  ttl                 = 1800

  record {
    value = "v=spf1 include:_mailcust.gandi.net ?all"
  }

  record {
    value = "google-site-verification=8Kgd48IOr7tCkIL_6-dWPM82YmkKhENpT2sw2i2ACJE"
  }
}

resource "azurerm_dns_cname_record" "cname_site_www" {
  name                = "www"
  zone_name           = azurerm_dns_zone.lsdrevampednet.name
  resource_group_name = azurerm_resource_group.lsdr_site.name
  ttl                 = 1800

  target_resource_id = azurerm_cdn_endpoint.site_cdn_endpoint.id
}

resource "azurerm_dns_cname_record" "cname_site_research" {
  name                = "research"
  zone_name           = azurerm_dns_zone.lsdrevampednet.name
  resource_group_name = azurerm_resource_group.lsdr_site.name
  ttl                 = 1800

  record = "hosting.gitbook.io"
}

resource "azurerm_dns_a_record" "a_site" {
  name                = "@"
  zone_name           = azurerm_dns_zone.lsdrevampednet.name
  resource_group_name = azurerm_resource_group.lsdr_site.name
  ttl                 = 1800

  target_resource_id = azurerm_cdn_endpoint.site_cdn_endpoint.id
}

resource "azurerm_dns_aaaa_record" "a_site" {
  name                = "@"
  zone_name           = azurerm_dns_zone.lsdrevampednet.name
  resource_group_name = azurerm_resource_group.lsdr_site.name
  ttl                 = 1800

  target_resource_id = azurerm_cdn_endpoint.site_cdn_endpoint.id
}
