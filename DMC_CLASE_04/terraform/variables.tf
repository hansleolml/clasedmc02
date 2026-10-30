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