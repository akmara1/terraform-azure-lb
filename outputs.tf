output "backend_pool" {
  value = azurerm_lb_backend_address_pool.example.id
}

output "nat_pool" {
  value = azurerm_lb_nat_pool.example.id
}