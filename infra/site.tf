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

resource "azurerm_cdn_profile" "site_cdn_profile" {
  name                = "cdn-lsdrevampednet"
  resource_group_name = azurerm_resource_group.lsdr_site.name
  location            = "westeurope"
  sku                 = "Standard_Microsoft"
}

resource "azurerm_cdn_endpoint" "site_cdn_endpoint" {
  name                = "ep-lsdrevampednet"
  resource_group_name = azurerm_resource_group.lsdr_site.name
  location            = azurerm_cdn_profile.site_cdn_profile.location
  profile_name        = azurerm_cdn_profile.site_cdn_profile.name
  origin {
    name      = "site"
    host_name = basename(azurerm_storage_account.site_storage_account.primary_web_endpoint)
  }
  origin_host_header = basename(azurerm_storage_account.site_storage_account.primary_web_endpoint)
  delivery_rule {
    name  = "EnforceHTTPS"
    order = 1
    request_scheme_condition {
      operator     = "Equal"
      match_values = ["HTTP"]
    }
    url_redirect_action {
      redirect_type = "Found"
      protocol      = "Https"
    }
  }
}

resource "azuread_service_principal" "cdn_service_principal" {
  application_id = "205478c0-bd83-4e1b-a9d6-db63a3e1e1c8"
}


resource "azurerm_key_vault" "site_cert_keyvault" {
  name                = "kvlsdrevampednet"
  resource_group_name = azurerm_resource_group.lsdr_site.name
  location            = azurerm_resource_group.lsdr_site.location
  tenant_id           = data.azurerm_client_config.terraform_service_principal.tenant_id
  sku_name            = "standard"
}

resource "azurerm_key_vault_access_policy" "terraform_access" {
  key_vault_id = azurerm_key_vault.site_cert_keyvault.id

  tenant_id = data.azurerm_client_config.terraform_service_principal.tenant_id
  object_id = data.azurerm_client_config.terraform_service_principal.object_id

  certificate_permissions = [
    "import", "update"
  ]
}

resource "azurerm_key_vault_access_policy" "azure_cdn_access" {
  key_vault_id = azurerm_key_vault.site_cert_keyvault.id

  tenant_id = data.azurerm_client_config.terraform_service_principal.tenant_id
  object_id = azuread_service_principal.cdn_service_principal.object_id

  certificate_permissions = [
    "get", "list"
  ]

  secret_permissions = [
    "get", "list"
  ]
}

resource "azurerm_key_vault_access_policy" "cert_function_access" {
  key_vault_id = azurerm_key_vault.site_cert_keyvault.id

  tenant_id = data.azurerm_client_config.terraform_service_principal.tenant_id
  object_id = var.cert_function_identity_object_id

  certificate_permissions = [
    "get", "list", "update", "import"
  ]
}
