resource "azurerm_resource_group" "lsdr_site" {
  name     = "rg-lsdr-site"
  location = "UK South"
}

resource "azurerm_storage_account" "site_storage_account" {
  name                     = "stlsdrevampednet"
  resource_group_name      = azurerm_resource_group.lsdr_site.name
  location                 = azurerm_resource_group.lsdr_site.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  static_website {
    index_document = "index.html"
  }
}
