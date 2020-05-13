terraform {
# backend "azurerm" {}

}

provider "azurerm" {
    # The "feature" block is required for AzureRM provider 2.x. 
    # If you're using version 1.x, the "features" block is not allowed.
    version = "~>2.0"
    features {}
    
   
}
// Get Keyvault Data
 
data "azurerm_key_vault" "terraform_vault" {              
  name                = var.keyvault_name                 
  resource_group_name = var.keyvault_rg                   
}                                                         
                                                          
data "azurerm_key_vault_secret" "ssh_public_key" {        
  name         = "VM-password"                           
  key_vault_id = data.azurerm_key_vault.terraform_vault.id
}   


module "corsearch_azurerm_rg_naming" {
  source     = "./modules/corsearch_rg_naming"
  namespace  = "corsearch"
  stage      = "testing"
  name       = "test1"
  attributes = ["Poc"]
  delimiter  = "-"

  tags = {
    "enviorenment" = "POC",
 }

}

resource "azurerm_resource_group" "poc-rg" {
  name     = module.corsearch_azurerm_rg_naming.id
  location = "West US 2"
  tags = module.corsearch_azurerm_rg_naming.tags
}