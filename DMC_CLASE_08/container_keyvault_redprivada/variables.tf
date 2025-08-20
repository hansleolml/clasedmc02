variable "location" {
  description = "La ubicación donde se creará el componente"
  type        = string
}

variable "tags" {
  description = "Etiquetas opcionales para aplicar al componente"
  type        = map(string)
  default = {
    Environment = ""
  }
}

// RESOURCE GROUP 01------------------------------- 
variable "rg_01_name" {
  description = "El nombre del grupo de recursos 1"
  type        = string
}

// Container Apps(ca) & Environments(cae) 01

variable "cae_01_workload_profile" {
  description = "El Workload del cae 01"
  type        = string
}

variable "cae_01_name" {
  description = "El nombre del cae 01"
  type        = string
}

variable "aca_01_name" {
  description = "El nombre del aca 01"
  type        = string
}

// identity
variable "identity_01_name" {
  description = "El nombre del identity 01"
  type        = string
}

// KeyVault

variable "kv_01_name" {
  description = "El nombre del keyvault 01"
  type        = string
}

variable "kv_pep_aca_01_name" {
  description = "El nombre del privante endpoint 01"
  type        = string
}

variable "kv_pep_aca_01_name_nic" {
  description = "el nombre de la nic de la privante endpoint 01"
  type        = string
}

// VNET 01 & SUBNET 01 y 02

variable "vnet_01_name" {
  description = "El nombre de la VNET 01"
  type        = string
}

variable "vnet_01_ip" {
  description = "Lista de espacios de direcciones IP en formato CIDR"
  type        = list(string)
}

variable "vnet_01_subnet_01_name" {
  description = "El nombre de la subnet 01 de la VNET 01"
  type        = string
}

variable "vnet_01_subnet_01_ip" {
  description = "Lista de espacios de direcciones IP en formato CIDR"
  type        = list(string)
}

variable "vnet_01_subnet_02_name" {
  description = "El nombre de la subnet 02 de la VNET 01"
  type        = string
}

variable "vnet_01_subnet_02_ip" {
  description = "Lista de espacios de direcciones IP en formato CIDR"
  type        = list(string)
}
