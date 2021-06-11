data "template_file" "nginx-vm-cloud-init" {
  template = file("script.sh")
}

# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "RGtftec" {
  name     = local.rgName
  location = var.location

  tags = (
    local.tags
  )
}


