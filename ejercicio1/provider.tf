resource "azurerm_resource_group" "rg-demo"{
    name = var.rg_name
    location = var.rg_location
    tags = {
        "Otro" = "OtroSuperTag"
        "Sec" = 2
    }
}