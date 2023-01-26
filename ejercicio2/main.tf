provider "azurerm" {
    subscription_id = "03060934-1854-4672-af41-1858fa2c655d"
    client_id ="*"
    client_secret = "*"
    tenant_id = "b4683825-d9b1-485b-9fea-cb659c4f1d3b"
    features {}
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

resource "azurerm_container_registry" "acr-demo" {
    name = var.acr_name
    resource_group_name = azurerm_resource_group.rg-demo.name
    location = azurerm_resource_group.rg-demo.location
    sku = var.acr_sku
    admin_enabled = var.acr_admin_enabled
}

resource "azurerm_kubernetes_cluster" "aks-demo" {
    name = var.aks_name
    location = azurerm_resource_group.rg-demo.location
    resource_group_name = azurerm_resource_group.rg-demo.name
    dns_prefix = var.aks_dns_prefix
    kubernetes_version = var.aks_kubernetes_version
    role_based_access_control_enabled = var.aks_rbac_enabled

    default_node_pool {
      name = var.aks_np_name
      node_count = var.aks_np_node_count
      vm_size = var.aks_np_vm_size
      vnet_subnet_id = azurerm_subnet.subnet-demo.id
      enable_auto_scaling = var.aks_np_enabled_auto_scaling
      max_count = var.aks_np_max_count
      min_count = var.aks_np_min_count
      max_pods  = var.aks_max_pods
    }

    service_principal {
      client_id = var.aks_sp_client_id
      client_secret = var.aks_sp_client_secret
    }
  
  network_profile {
    network_plugin = var.aks_net_plugin
    network_policy = var.aks_net_policy
    service_cidr = "10.0.4.0/24"
    dns_service_ip = "10.0.4.10"
    docker_bridge_cidr = "172.17.0.1/16"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "extra-node" {
  name                  = "adicional"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks-demo.id
  vm_size               = var.aks_np_vm_size
  max_count             = var.aks_np_min_count
  min_count             = var.aks_np_min_count
  max_pods              = var.aks_max_pods
  enable_auto_scaling   = true

  tags = {
    Environment = "Adicional"
  }
}