

module "resource_group" {
  source              = "./modules/resource_group"
  resource_group_name = "ddm-rg-1"
  location            = "East US"
}

module "virtual_network" {
  source              = "./modules/virtual_network"
  name                = "ddm_vpc"
  resource_group_name = module.resource_group.resource_group_name
  location            = "East US"
  address_space       = ["10.0.0.0/16"]
}

module "subnet" {
  source               = "./modules/subnets"
  name                 = "ddm_subnet"
  resource_group_name  = module.resource_group.resource_group_name
  virtual_network_name = module.virtual_network.virtual_network_name
  address_prefixes     = ["10.0.1.0/24"]
}

module "public_ip" {
  source              = "./modules/public_address"
  resource_group_name = module.resource_group.resource_group_name
  location            = "East US"
  public_ip_name      = "ddm_public_ip"
}

module "agw_subnet" {
  source               = "./modules/subnets"
  name                 = "agw-subnet"
  resource_group_name  = module.resource_group.resource_group_name
  virtual_network_name = module.virtual_network.virtual_network_name
  address_prefixes     = ["10.0.0.0/24"]
}

module waf{
  source   = "./modules/webapplication_firewall"
  resource_group_name  = module.resource_group.resource_group_name
  location             = "East US"

}

module "apgw" {
  source                   = "./modules/application_gateway"
  application_gateway_name = "ddm_apwg"
  resource_group_name      = module.resource_group.resource_group_name
  location                 = "East US"
  public_id                = module.public_ip.public_ip_id
  subnet_id                = module.agw_subnet.subnet_id
  firewall_policy_id        = module.waf.firewall_policy_id
  frontend_port_name       = [{
    name = "ddm_frontend_port"
    port = 80
  },
 ]
  backend_address_pool_name  = ["ddm_backend_pool_images"]

  frontend_ip_configuration_name = [
    {
      name                 = "ddm_Config"
      public_ip_address_id = module.public_ip.public_ip_id
    },
  ]

  http_setting_name = [
    {
      name                  = "ddmHTTPsetting_images"
      cookie_based_affinity = "Disabled"
      port                  = 80
      protocol              = "Http"
      request_timeout       = 60
    }
  
  ]

  listener_name = [
    {
      name                           = "ddmListener_images"
      frontend_ip_configuration_name = "ddm_Config"
      frontend_port_name              = "ddm_frontend_port"
    },
   
  ]

  request_routing_rule_name = [
    {
      name                        = "ddmRoutingRule_images"
      rule_type                   = "Basic"
      http_listener_name          = "ddmListener_images"
      backend_address_pool_name   = "ddm_backend_pool_images"
      backend_http_settings_name  = "ddmHTTPsetting_images"
      priority                    = 1
    
      
    },
  ]


}
