output "public-ip"{
    value = azurerm_public_ip.pip-demo.ip_address
}

output "username" {
    value = azurerm_linux_virtual_machine.vm-demo.admin_username
}

/*output "password" {
    value = azurerm_linux_virtual_machine.vm-demo.admin_password
}*/