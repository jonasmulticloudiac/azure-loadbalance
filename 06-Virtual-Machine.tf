resource "azurerm_availability_set" "AVAtftec" {
  name                         = "AVA-tftec"
  location                     = azurerm_resource_group.RGtftec.location
  resource_group_name          = azurerm_resource_group.RGtftec.name
  platform_fault_domain_count  = "2"
  platform_update_domain_count = "2"
  managed                      = true


  tags = (
    local.tags
  )
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.RGtftec.name
  }

  byte_length = 8
}

# Create (and display) an SSH key
resource "tls_private_key" "SSHtftec" {
  algorithm = "RSA"
  rsa_bits  = 4096
}



# Create storage account for boot diagnostics
resource "azurerm_storage_account" "STORAGEtftec" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.RGtftec.name
  location                 = local.tags.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = (
    local.tags
  )
}


# Create virtual machine
resource "azurerm_linux_virtual_machine" "VMtftec" {
  count                 = var.numVMS
  name                  = "VM-tftec-${count.index}"
  location              = local.tags.location
  resource_group_name   = azurerm_resource_group.RGtftec.name
  network_interface_ids = [element(azurerm_network_interface.NICtftec.*.id, count.index)]
  size                  = "Standard_B1s"
  availability_set_id   = azurerm_availability_set.AVAtftec.id



  os_disk {
    name                 = "myOsDisk-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "mvtftec-${count.index}"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.SSHtftec.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.STORAGEtftec.primary_blob_endpoint
  }

  tags = (
    local.tags
  )

  custom_data = base64encode(data.template_file.nginx-vm-cloud-init.rendered)

}


resource "azurerm_managed_disk" "EXTRAHDtftec" {
  count                = var.numVMS
  name                 = "${local.vmName}-disk${count.index}"
  location             = azurerm_resource_group.RGtftec.location
  resource_group_name  = azurerm_resource_group.RGtftec.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 20
}
