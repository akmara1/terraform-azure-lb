# Puclic Ip
resource "azurerm_public_ip" "example" {
  name                = "pip-${var.name}"
  location            = var.loc
  resource_group_name = var.rg
  allocation_method   = "Static"
  sku                 = "Standard"
}

# load balancer
resource "azurerm_lb" "example" {
  name                = "lb-${var.name}"
  location            = var.loc
  resource_group_name = var.rg
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.example.id
  }

}

# backend pool
resource "azurerm_lb_backend_address_pool" "example" {
  loadbalancer_id = azurerm_lb.example.id
  name            = "backend-pool-${var.name}"
}

# health probe
resource "azurerm_lb_probe" "example" {
  resource_group_name = var.rg
  loadbalancer_id     = azurerm_lb.example.id
  name                = "http-running-probe"
  port                = var.port
}

# load balancing rule
resource "azurerm_lb_rule" "example" {
  resource_group_name            = var.rg
  loadbalancer_id                = azurerm_lb.example.id
  name                           = "lb_rule"
  protocol                       = "Tcp"
  frontend_port                  = var.port
  backend_port                   = var.port
  backend_address_pool_id        = azurerm_lb_backend_address_pool.example.id
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.example.id
}

# nat pool
resource "azurerm_lb_nat_pool" "example" {
  resource_group_name            = var.rg
  loadbalancer_id                = azurerm_lb.example.id
  name                           = "Pool"
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50001
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}

# nat rule
resource "azurerm_lb_nat_rule" "nat-rule" {
  resource_group_name            = var.rg
  loadbalancer_id                = azurerm_lb.example.id
  name                           = "HttpAccess"
  protocol                       = "Tcp"
  frontend_port                  = 5000
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}



