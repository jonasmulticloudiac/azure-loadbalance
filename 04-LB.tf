# Create a Load Balancer Resource. 
resource "azurerm_lb" "LBtftec" {
  name                = "LB-tftec"
  location            = azurerm_resource_group.RGtftec.location
  resource_group_name = azurerm_resource_group.RGtftec.name


  frontend_ip_configuration {
    name                 = "LB-Frontend"
    public_ip_address_id = azurerm_public_ip.PUBIPtftec.id
  }

}

# Create  Load Balancer Backend Address Pool. 
resource "azurerm_lb_backend_address_pool" "LBPOOLtftec" {
  loadbalancer_id = azurerm_lb.LBtftec.id
  name            = "BackEndAddressPool"

}

# Create a  LoadBalancer Probe Resource.
resource "azurerm_lb_probe" "LBPROBEtftec" {
  resource_group_name = azurerm_resource_group.RGtftec.name
  loadbalancer_id     = azurerm_lb.LBtftec.id
  name                = "http-probe"
  protocol            = "Http"
  request_path        = "/"
  port                = 80
}

#Create a  Load Balancer Rule.
resource "azurerm_lb_rule" "LBNATRULEtftec" {
  resource_group_name            = azurerm_resource_group.RGtftec.name
  loadbalancer_id                = azurerm_lb.LBtftec.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "LB-Frontend"
  probe_id                       = azurerm_lb_probe.LBPROBEtftec.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.LBPOOLtftec.id

}


resource "azurerm_lb_nat_rule" "LBNATtfetc" {
  resource_group_name            = azurerm_resource_group.RGtftec.name
  loadbalancer_id                = azurerm_lb.LBtftec.id
  name                           = "LBNATRULE-ssh"
  protocol                       = "Tcp"
  frontend_port                  = 22500
  backend_port                   = 22
  frontend_ip_configuration_name = "LB-Frontend"

}