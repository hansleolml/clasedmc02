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

variable "rg_02_name" {
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

