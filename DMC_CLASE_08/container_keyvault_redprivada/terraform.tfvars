location = "East US 2"
tags = {
  Environment = "Desarrollo"
  Department  = "TI"
  Clase       = "DMC"
}
// RESOURCE GROUP 01------------------------------- 
rg_01_name = "rg-hansqm2-dev-eastus2-001"

// Environments(cae)
cae_01_name             = "cae-hansqm2-dev-eastus2-001"
cae_01_workload_profile = "Consumption"

// Container Apps(ca)
aca_01_name = "ca-hansqm2-dev-eastus2-001"

//identity 

identity_01_name = "id-hansqm2-dev-eastus2-001"

//Keyvault

kv_01_name             = "kvhansqm3deveastus2001"
kv_pep_aca_01_name     = "pep-hansqm2-dev-eastus2-001"
kv_pep_aca_01_name_nic = "pep-hansqm2-dev-eastus2-001-nic"


// VNET 01 & SUBNET 01
vnet_01_name = "vnet-hansqm2-dev-eastus2-001"
vnet_01_ip   = ["10.100.0.0/16"] #65,536 ips disponibles

vnet_01_subnet_01_name = "snet-hansqm2-dev-eastus2-001"
vnet_01_subnet_01_ip   = ["10.100.0.0/20"] // subnet para container app environment, solo se acepta menos de 22 

vnet_01_subnet_02_name = "snet-hansqm2-dev-eastus2-002"
vnet_01_subnet_02_ip   = ["10.100.16.0/24"] // para private endpoint