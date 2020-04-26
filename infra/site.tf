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

data "azurerm_client_config" "terraform_service_principal" {
}

resource "azurerm_role_assignment" "terraform_sp_blob_contributor" {
  scope                = azurerm_storage_account.site_storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.terraform_service_principal.object_id
}
