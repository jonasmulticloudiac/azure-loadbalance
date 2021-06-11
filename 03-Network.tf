# Create virtual network
resource "azurerm_virtual_network" "VNETtftec" {
  name                = "VNET-tftec"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.RGtftec.name

  tags = (
    local.tags
  )
}

# Create subnet
resource "azurerm_subnet" "SUBtftec" {
  name                 = "SUB-tftec"
  resource_group_name  = azurerm_resource_group.RGtftec.name
  virtual_network_name = azurerm_virtual_network.VNETtftec.name
  address_prefixes     = ["10.0.1.0/24"]

}

# Create public IPs
resource "azurerm_public_ip" "PUBIPtftec" {
  name                = "PUBIPtftec "
  location            = var.location
  resource_group_name = azurerm_resource_group.RGtftec.name
  allocation_method   = "Static"

}


# Create network interface
resource "azurerm_network_interface" "NICtftec" {
  count               = var.numVMS
  name                = "NIC-${count.index}-tftec"
  location            = var.location
  resource_group_name = azurerm_resource_group.RGtftec.name

  ip_configuration {
    name                          = "NICconf-tftec"
    subnet_id                     = azurerm_subnet.SUBtftec.id
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id          = azurerm_public_ip.PUBIPtftec.id
  }
}


#Associated nic-interface to backend-pool
resource "azurerm_network_interface_backend_address_pool_association" "NIBACKPOOLAStftec" {
  count                   = var.numVMS
  network_interface_id    = element(azurerm_network_interface.NICtftec.*.id, count.index)
  ip_configuration_name   = "NICconf-tftec"
  backend_address_pool_id = azurerm_lb_backend_address_pool.LBPOOLtftec.id
}


# Create Network Security Group and rule
resource "azurerm_network_security_group" "NSGtftec" {
  name                = "NSG-tftec"
  location            = var.location
  resource_group_name = azurerm_resource_group.RGtftec.name

  tags = {
    environment = var.environment
  }

}


resource "azurerm_application_security_group" "ASGtftec" {
  name                = "ASG-tftec"
  location            = azurerm_resource_group.RGtftec.location
  resource_group_name = azurerm_resource_group.RGtftec.name

  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_security_rule" "NSGRULEStftec" {

  for_each               = local.nsgrules
  name                   = each.value.name
  priority               = each.value.priority
  direction              = each.value.direction
  access                 = each.value.access
  protocol               = each.value.protocol
  source_port_range      = each.value.source_port_range
  destination_port_range = each.value.destination_port_range
  source_address_prefix  = each.value.source_address_prefix
  #destination_address_prefix  = each.value.destination_address_prefix
  #source_application_security_group_ids = [azurerm_application_security_group.ASGtftec.id]
  destination_application_security_group_ids = [azurerm_application_security_group.ASGtftec.id]
  network_security_group_name                = azurerm_network_security_group.NSGtftec.name
  resource_group_name                        = azurerm_resource_group.RGtftec.name


}


#Associated Network-security-group to Sub-net
resource "azurerm_subnet_network_security_group_association" "NISGASStftec" {
  subnet_id                 = azurerm_subnet.SUBtftec.id
  network_security_group_id = azurerm_network_security_group.NSGtftec.id

}

resource "azurerm_network_interface_application_security_group_association" "NICASGtftec" {
  count                         = var.numVMS
  network_interface_id          = element(azurerm_network_interface.NICtftec.*.id, count.index)
  application_security_group_id = azurerm_application_security_group.ASGtftec.id
}
