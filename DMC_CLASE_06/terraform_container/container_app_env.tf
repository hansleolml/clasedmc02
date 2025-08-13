resource "azurerm_container_app_environment" "cae_01" {
  name                               = var.cae_01_name
  location                           = azurerm_resource_group.rg_01.location
  resource_group_name                = azurerm_resource_group.rg_01.name
  infrastructure_resource_group_name = var.cae_01_name
  tags = merge(var.tags, {
    Workload = "Transversal"
  })

  workload_profile {
    name                  = var.cae_01_workload_profile
    workload_profile_type = var.cae_01_workload_profile
  }
  lifecycle {
    ignore_changes = [
      infrastructure_resource_group_name
    ]
  }
}

resource "azurerm_container_app" "aca_01" {
  name                         = var.aca_01_name
  container_app_environment_id = azurerm_container_app_environment.cae_01.id
  resource_group_name          = azurerm_resource_group.rg_01.name
  revision_mode                = "Single"
  workload_profile_name        = "Consumption"
  template {
    min_replicas = 1
    container {
      name   = "examplecontainerapp"
      image  = "docker.io/nginxdemos/hello:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
  ingress {
    external_enabled           = true
    target_port                = 80
    allow_insecure_connections = false

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }

  }
  lifecycle {
    ignore_changes = [
      template[0].container[0].volume_mounts,
      template[0].volume,
      #template[0].container[0].image
    ]
  }
}