provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "=1.21.0"
  client_id = "${var.client_id}"
  client_secret = "${var.client_secret}"
  subscription_id = "${var.subscription_id}"
  tenant_id = "${var.tenant_id}"

}

resource "azurerm_resource_group" "aci-rg" {
  name     = "${var.rg_group_name}"
  location = "${var.location}"
}

resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = "${azurerm_resource_group.aci-rg.name}"
  }

  byte_length = 8
}

resource "azurerm_storage_account" "aci-sa" {
  name                = "acisa${random_id.randomId.hex}"
  resource_group_name = "${azurerm_resource_group.aci-rg.name}"
  location            = "${azurerm_resource_group.aci-rg.location}"
  account_tier        = "Standard"

  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "aci-share" {
  name                 = "${var.share_name}"
  resource_group_name  = "${azurerm_resource_group.aci-rg.name}"
  storage_account_name = "${azurerm_storage_account.aci-sa.name}"

  quota = 50
}

resource "azurerm_container_group" "aci-cg" {
  name                = "aci-agent"
  location            = "${azurerm_resource_group.aci-rg.location}"
  resource_group_name = "${azurerm_resource_group.aci-rg.name}"
  ip_address_type     = "public"
  os_type             = "linux"

  container {
    name   = "vsts-agent"
    image  = "${var.container_image}"
    cpu    = "0.5"
    memory = "1.5"
    ports  = {
      port     = 80
      protocol = "TCP"
    }

    environment_variables {
      "VSTS_ACCOUNT" = "${var.vsts-account}"
      "VSTS_TOKEN"   = "${var.vsts-token}"
      "VSTS_AGENT"   = "${var.vsts-agent}"
      "VSTS_POOL"    = "${var.vsts-pool}"
    }

    volume {
      name       = "logs"
      mount_path = "/aci/logs"
      read_only  = false
      share_name = "${azurerm_storage_share.aci-share.name}"

      storage_account_name = "${azurerm_storage_account.aci-sa.name}"
      storage_account_key  = "${azurerm_storage_account.aci-sa.primary_access_key}"
    }
  }

  tags {
    environment = "test"
  }
}
