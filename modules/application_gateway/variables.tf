variable "application_gateway_name" {
    type = string
}

variable "resource_group_name" {
    type = string
}

variable "location" {
    type = string
}

variable "backend_address_pool_name" {
    type = list(string)
}

variable "frontend_port_name" {
    type = list(map(string))
}

variable "frontend_ip_configuration_name" {
    type = list(map(string))
}

variable "http_setting_name" {
    type = list(map(string))
}

variable "listener_name" {
    type = list(map(string))
}

variable "request_routing_rule_name" {
    type = list(object({
        name                       = string
        rule_type                  = string
        http_listener_name         = string
        priority                   = number
        backend_address_pool_name  = string
        backend_http_settings_name = string





    }))
}

variable "public_id" {}

variable "subnet_id" {}

variable "firewall_policy_id"{

}







