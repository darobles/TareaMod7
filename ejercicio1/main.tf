provider "azurerm" {
    subscription_id = "03060934-1854-4672-af41-1858fa2c655d"
    client_id ="*"
    client_secret = "*"
    tenant_id = "b4683825-d9b1-485b-9fea-cb659c4f1d3b"
    features {}
}

resource "azurerm_public_ip" "pip-demo" {
    name                = "public-ip"
    resource_group_name = azurerm_resource_group.rg-demo.name
    location            = azurerm_resource_group.rg-demo.location
    allocation_method   = "Static"
    tags = {
        "diplomado" = "sec2"
    } 
}

resource "azurerm_virtual_network" "vnet-demo" {
    name = "diplo-net"
    address_space = ["10.0.0.0/16"]
    location = azurerm_resource_group.rg-demo.location
    resource_group_name = azurerm_resource_group.rg-demo.name
}

resource "azurerm_subnet" "subnet-demo"{
    name = "internal"
    resource_group_name = azurerm_resource_group.rg-demo.name
    virtual_network_name = azurerm_virtual_network.vnet-demo.name
    address_prefixes = ["10.0.2.0/24"]
}
resource "azurerm_network_interface" "netinter-demo" {
    name = "networkinterface"
    location = azurerm_resource_group.rg-demo.location
    resource_group_name = azurerm_resource_group.rg-demo.name
    ip_configuration {
        name = "internal"
        subnet_id = azurerm_subnet.subnet-demo.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.pip-demo.id
    }
}

resource "azurerm_linux_virtual_machine" "vm-demo" {
    name = "diplo-machine"
    location = azurerm_resource_group.rg-demo.location
    resource_group_name = azurerm_resource_group.rg-demo.name
    size = "Standard_B1s"
    network_interface_ids = [ azurerm_network_interface.netinter-demo.id ]
    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "RedHat"
        offer = "RHEL"
        sku = "79-gen2"
        version = "latest"
    }

    computer_name = "hostname"
    admin_username = "daniel"
    admin_password = "Diplomado!"
    disable_password_authentication = false
}