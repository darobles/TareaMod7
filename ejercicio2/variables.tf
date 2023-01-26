# Resource Group
variable "rg_name" {}
variable "rg_location" {}
variable "rg_group" {}

# Virtual Network
variable "vnet_name" {}
variable "vnet_address_space" {}

# Subnet
variable "subnet_name" {}
variable "subnet_address_prefixes" {}

# Container Registry
variable "acr_name" {}
variable "acr_sku" {}
variable "acr_admin_enabled" {}

# Kubernetes Service
variable "aks_name" {}
variable "aks_dns_prefix" {}
variable "aks_kubernetes_version" {}
variable "aks_rbac_enabled" {}
variable "aks_np_name" {}
variable "aks_np_node_count" {}
variable "aks_np_vm_size" {}
variable "aks_np_enabled_auto_scaling" {}
variable "aks_np_max_count" {}
variable "aks_np_min_count" {}
variable "aks_sp_client_id" {}
variable "aks_sp_client_secret" {}
variable "aks_net_plugin" {}
variable "aks_net_policy" {}
variable "aks_max_pods" {}