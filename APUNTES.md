
## VM - linux Comandos

    sudo ufw allow 8080     -> open port

   
## Arquitectura Kubernetes

- **Control Plane**
    cerebro del cluster y administra todas las operaciones del mismo. 
    Los componentes del plano de control incluyen:
    - **API Server**: Es el punto de entrada para todas las comunicaciones dentro del cluster. 
            Gestiona las solicitudes a través de kubectl.
            expone la API de Kubernetes.

    - **Etcd**: BD distribuida, de almacenamiento de valor clave con tolerancia a fallos, 
        guarda los datos de configuración y la información sobre el estado del clúster.

    - **Controller Manager**: Ejecuta los controladores que regulan el estado del cluster. 
                Controlador de Nodos , replicas , endpoints
                Controlador de Rutas
                Controlador de Servicios
    - **Scheduler**: asignar los pods a nodos disponibles según criterios como 
                la carga del sistema, 
                las políticas de afinidad, 
                la disponibilidad de recursos, etc.
- Worker nodes

## Servicio Kubernetes   
- Service: is a method for exposing a network application that is running as one or more Pods in your cluster.
    Permite establecer una IP o un hostanme a un servicio implementado por uno o mas pods backends.
    
    - ClusterIP: Permite acceder a un conjunto de Pods desde dentro del clúster, pods pueden comunicarse mediante:
        asigna una IP virtual interna (ClusterIP)
        también asigna un nombre DNS interno al servicio            

        ```yaml
        apiVersion: v1
        kind: Service
        metadata:
            name: my-service
        spec:
            selector:
            app: my-app
            ports:
            - protocol: TCP
                port: 80
                targetPort: 8080
            type: ClusterIP
        ```
    - NodePort:  expone el servicio en un puerto específico en cada nodo del clúster.
        Permite acceder a los Pods desde fuera del clúster, utilizando la IP 
        de cualquiera de los nodos del clúster en un puerto específico
        El puerto expuesto es un puerto alto (30000–32767)

        ```yaml
        apiVersion: v1
        kind: Service
        metadata:
            name: my-nodeport-service
        spec:
            selector:
            app: my-app
            ports:
            - protocol: TCP
                port: 80
                targetPort: 8080
                nodePort: 30007
            type: NodePort
        ```
    - Load Balancer: expone un servicio a través de un balanceador de carga externo 
        distribuir el tráfico entre los Pods
        asignan una IP pública para el servicio

        ```yaml
        apiVersion: v1
        kind: Service
        metadata:
            name: my-loadbalancer-service
        spec:
            selector:
            app: my-app
            ports:
            - protocol: TCP
                port: 80
                targetPort: 8080
            type: LoadBalancer
        ```        

## Ingresss Kubernetes 
- **Ingress Resource:** 
    - Es el objeto de Kubernetes que define las reglas de enrutamiento HTTP/HTTPS para dirigir el tráfico externo a los servicios dentro del clúster. 
    - Aquí se pueden definir rutas basadas en URL, nombres de dominio, y gestionar certificados TLS para HTTPS

- **Ingress Controller:**
    - Es el componente que implementa las reglas definidas en los recursos de Ingress. 
    - Kubernetes no incluye un Ingress Controller por defecto,  controladores mas comunes:
        - NGINX Ingress Controller
        - Traefik Ingress Controller
        - Aplication Gateway Ingress Controller (AGIC) -> es de Azure

    ### Ejemplo Ingress
    #### 1. Crear dos deployments

    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: hello-v1
      namespace: ingressns
    spec:
      replicas: 3
      selector:
        matchLabels:
          app: hello-v1
      template:
        metadata:
          labels:
            app: hello-v1
        spec:
          containers:
          - name: hello
            image: us-docker.pkg.dev/google-samples/containers/gke/hello-app:1.0
            ports:
            - containerPort: 8080
    ```
    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: hello-v2
      namespace: ingressns
    spec:
      replicas: 3
      selector:
        matchLabels:
          app: hello-v2
      template:
        metadata:
          labels:
            app: hello-v2
        spec:
          containers:
          - name: hello
            image: us-docker.pkg.dev/google-samples/containers/gke/hello-app:2.0
            ports:
            - containerPort: 8080
    ```
    #### 2. Crear un Service tipo ClusterIP
    Ahora necesitas un Service que exponga los Pods creados por el Deployment. Este servicio será usado por el Ingress para redirigir el tráfico hacia los Pods

    ```yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: hello-v1-svc
      namespace: ingressns
    spec:
      selector:
        app: hello-v1
      ports:
        - protocol: TCP
          port: 80
          targetPort: 8080
      type: ClusterIP
    ```
    ```yaml
    apiVersion: v2
    kind: Service
    metadata:
      name: hello-v2-svc
      namespace: ingressns
    spec:
      selector:
        app: hello-v2
      ports:
        - protocol: TCP
          port: 80
          targetPort: 8080
      type: ClusterIP
    ```
    #### 3. Crea un ingress
    El Ingress expondrá el servicio al mundo exterior a través de reglas de enrutamiento basadas en el nombre de dominio o la ruta.
    **Please note that the ingress resource should be placed inside the same namespace of the backend resource**
    
    ```yaml
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: ingress
      namespace: ingressns
      #annotations:    //azure AGIC
        #nginx.ingress.kubernetes.io/rewrite-target: /    //azure AGIC
    spec:
      # ingressClassName: azure-application-gateway       //azure AGIC
      rules:
      - host: v1.hansquirozm.com  # Aquí puedes poner un dominio válido o localhost
        http:
          paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: hello-v1-svc
                port:
                  number: 80
      - host: hansquirozm.com  # Aquí puedes poner un dominio válido o localhost
        http:
          paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: hello-v2-svc
                port:
                  number: 80
      ingressClassName: nginx
    ```
    #### 4. Obtener ip publica del ingress creado
        kubectl get ing -n ingressns

        NAME      CLASS                       HOSTS                                ADDRESS        PORTS   AGE
        ingress   azure-application-gateway   v1.hansquirozm.com,hansquirozm.com   20.10.117.31   80      3h34m

    ### 5. Configurar dominio y apuntar a la ip publica del ingress
    - Se añade la siguientes record:
        - Type: A , name: @ , ipv4: 20.10.117.31 -> en este caso @ es para el root osea el dominio completo
        - Type: A , name: v1 , ipv4: 20.10.117.31 -> v1 para el subdominio = v1.hansquirozm.com
    - **Cloudfire configuro automaticamente certificado SSL**
    - Corroborar TXT de dominio: https://www.skysnag.com/es/txt-record-lookup/


## Ingress Controler
- para AKS solo es compatible con : Azure CNI NODE SUBNET (gestiona el tráfico y las IP virtuales, no es compatible con CNI overlay)
- Installar Nginx Ingress Controller en Azure
    - kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.2/deploy/static/provider/cloud/deploy.yaml
- Documentación
    - https://kubernetes.github.io/ingress-nginx/deploy/#quick-start 
- desactivar Ingress Control AD ons de azure
    - az aks disable-addons -n <AKS-cluster-name> -g <AKS-resource-group-name> -a ingress-appgw 

## Comandos Kubernetes
    kubernetes validar archivo , validate ? fmt ?
    
    k config get-contexts
    k config use-context aks-alimarket-dev-eastus-01-admin


## Git branch estragias
- **Trunk-based development:**
    - se trabaja sobre la trama principal master(trunk)
    - Busca la entrega de cambios pequeños, de forma rapida y continua
    - se crea rama secundarias y se integra usualmente, estos cambios son pequeños
        para cambios grandes se usan feature flags(oculta los pequeños cambios)
    - las ramas siempre tienen que ser de corta duración (horas o dias)
    - CI and automated testing play a crucial role in maintaining code quality and stability.
    - usar bajo estos 2 escenarios:
        - proyecto de ciclo de entrega rapido, entregas frecuentes y Continuos
        - equipo de desarrollo pequeño

- **Feature branch workflow**
    - Developers create a new branch for each feature or issue they are working on, develop and test the changes in isolation, 
    and then merge the feature branch back into the main branch once it's complete and tested.
    - rama principal master, y se crea ramas secundarias nombre "feature"

- **Release branch workflow**
    -  se crea una rama dedicada a partir de la rama principal cuando se prepara un lanzamiento. 
    se utiliza para estabilizar el código,bugs, errores y pruebas antes lanzamiento en producción.
    - se crea tags 1.1 , 1.2 etc, si uno falla se regresa a la version anterior

- **Forking workflows**
    - un único repositorio del lado del servidor que actúe como base de código "central", 
    proporciona a cada desarrollador un repositorio del lado del servidor
    -  cada colaborador tiene dos repositorios de Git: uno local privado y uno público del lado del servidor.
    - The forking workflow is most often seen in public open-source projects.

## Deployment strategies
    RunOnce: El despliegue RunOnce es el enfoque más simple. 
                Implementa una nueva versión de la aplicación en todos los servidores o instancias de una sola vez. 
        ______________________________________________________________________________
        strategy:
            runOnce:
                preDeploy:
                    pool: [ server | pool ] # See pool schema.
                    steps:
                deploy:
                on:
                    failure:
                    success:
        ______________________________________________________________________________

    Rolling Deployment:  El Rolling Deployment despliega la nueva versión de la aplicación gradualmente en las instancias o servidores, 
                uno a uno, o en pequeños lotes, algunas instancias seguirán ejecutando la versión anterior de la aplicación
        _________________________________________________________________________________
        strategy:
            rolling:
                maxParallel: [ number or percentage as x% ]
                preDeploy:       
                    steps:
                    - script: [ script | bash | pwsh | powershell | checkout | task | templateReference ]
                deploy:       
        _________________________________________________________________________________
    Canary: Una nueva versión de la aplicación se despliega en un pequeño subconjunto de instancias(conocidos como canaries). 
                Después de monitorear el rendimiento y la estabilidad, la nueva versión se implementa gradualmente en todas las instancias.
                - si se desplego en el 10% y confirmamos que todo bien , en el mismo pipeline se debe poner un boton donde se confirmara
                    que todo es correcto y se procedera a desplegar en el 90% restante , (task: ManualValidation@0)
        ______________________________________________________________________________
        strategy:
            canary:
                increments: [ number ]
                preDeploy:       
                    pool: [ server | pool ] # See pool schema.       
                    steps:
                    - script: [ script | bash | pwsh | powershell | checkout | task | templateReference ]
                deploy:         
        ____________________________________________________________________________

## Tipos de tests

    Unit testing: probar unidades individuales de código, generalmente funciones o métodos, de forma aislada.
    Integration testing: evaluates interactions between different components
    Functional testing: probar una funcionalidad completa del sistema, como una característica o flujo de trabajo.
    Smoke testing: es determinar si las funcionalidades críticas del software funcionan como se espera 
    UI testing: validates that application user interfaces 
    Stress testing 
    Security testing 
    End-to-end testing

## CMD , RUN , ENTRYPOINT
    RUN -> Ejecutar comandos almomento de construir imagenes    
        run apt add bin

    CMD -> Se ejecuta por defecto al correr el contenedor
        CMD ["python","usr/scr/myapp/server.py"]
        -   corre un comando por defecto que es faclmente sobreescribible

    Entrypoint -> se ejecuta para un contenedor no es reemplazable

## comandos de docker
    docker run -d -p 8080:80 --name my-nginx nginx
    docker ps -a --filter "status=exited"
    docker pull ubuntu:latest
    docker build -t my-app:v1.0 -f Dockerfile.custom .
        - construye imagen usando un dockerfile (dockerfile.custom)
    docker exec -it my-container bash
    docker stop -t 10 my-container
        - detiene un contenedor en 10 seg
    docker restart -t 5 my-container
    docker rm -f my-container   
    docker rmi -f my-image
    docker logs -f --tail 10 my-container
    docker-compose up -d --build
    docker top my-container
        - Muestra los procesos que se están ejecutando dentro de un contenedor.
    docker system prune -a --volumes
    docker tag my-image:latest my-repo/my-image:v1.0
        docker tag jnlp-slave:adopt-alicorp-v5 alicorpdevops.azurecr.io/jnlp-slave:adopt-alicorp-v5
        -  Asigna una etiqueta (tag) a una imagen para versionarla o renombrarla
    docker push cricpnawebqaeastus2001.azurecr.io/mi-imagen:latest
    docker inspect -f '{{ .NetworkSettings.IPAddress }}' my-container
    docker volume ls -f dangling=true
    docker network ls -f driver=bridge
    docker attach --no-stdin my-container
    docker commit -m "Actualización del servidor" -a "Juan" my-container my-new-image:v2

## Comandos de GIT
    git init
    git clone https://github.com/usuario/repo.git
    git add archivo.txt
    git commit -m "Mensaje del commit"
    git status
    git log --oneline
    git diff HEAD^ HEAD -- hola.txt
        git diff <commit-hash> HEAD -- hola.txt
    git branch nueva-rama
    git checkout -b nueva-rama
        -b (crear y cambiar a una nueva rama)
    git checkout <commit-hash>
    git push/pull origin master
    git reset --hard HEAD~1
        git reset --hard <commit-hash>
    git fetch origin
        - Descarga las actualizaciones del repositorio remoto sin fusionarlas.
    git remote add origin https://github.com/usuario/repo.git

## Shell Scripting
    nano hola_mundo.sh

    #!/bin/bash
    # Un simple script para imprimir "Hola, Mundo!"
    echo "Hola, Mundo!"

    chmod +x hola_mundo.sh
    ./hola_mundo.sh


    Eliminar Pods con estado "CrashLoopBackOff
    
        #!/bin/bash
        # Script para eliminar pods en estado CrashLoopBackOff

        echo "Buscando pods en estado CrashLoopBackOff..."
        PODS=$(kubectl get pods --all-namespaces --field-selector=status.phase!=Running -o jsonpath="{.items[?(@.status.containerStatuses[0].state.waiting.reason=='CrashLoopBackOff')].metadata.name}")

        for POD in $PODS; do
            echo "Eliminando pod $POD..."
            kubectl delete pod $POD --force --grace-period=0
        done

## MAVEN
    Jerarquía de fases en Maven:
        Cuando ejecutas una fase avanzada, Maven ejecuta todas las fases anteriores en el ciclo de vida:

        clean: Elimina archivos, la carpeta target, los .class y .properties
            mvn clean
        compile: Fase validate + compile = compila el codigo
        test: Validate + compile + test = ejecuta las pruebas unitarias
            mvn test -Dtest=NombreClaseDePrueba // prueba especifica
        package: Validate + compile + test + package = crea el binario .jar o .war
            mvn -f /home/app/pom.xml clean package -DskipTests// con -f especifico donde esta el pom y con el -DskipTests puedo omitir las pruebas unitarias
        install: Validate + compile + test + package + install = Instala el paquete en el repositorio local, para usarlo como dependencia en otros proyectos.
        deploy: Validate + compile + test + package + install + deploy = Copia el paquete final al repositorio remoto,

## GRADLE
    Jerarquía de fases en Gradle:
        clean: Elimina los archivos generados en la compilación previa, generalmente dentro del directorio build/
            gradle clean 
        Compilación: 
            gradle compileJava
        test: 
            gradle test
        build: compile + test + empaquetar =  crea el binario .jar 
            gradle clean build -> agrego el clean para limpiar archivos 
        install: Instala el paquete en un repositorio loca
            gradle install

## NGINX

    /etc/nginx/nginx.conf ->  archivo principal de configuración de NGINX

    /etc/nginx/sites-available/: archivos de configuración para los diferentes sitios web que quieras servir.
            (Virtual Hosts)

        server {
            listen 80;
            server_name ejemplo.com www.ejemplo.com;

            root /var/www/ejemplo.com;
            index index.html index.htm;

            location / {
                try_files $uri $uri/ =404;
            }

            error_page 404 /404.html;
        }
        
    /etc/nginx/sites-enabled/: enlaces simbólicos a los archivos que están en sites-available 
                            representan los sitios que están actualmente activos.

    sudo ln -s /etc/nginx/sites-available/misitio /etc/nginx/sites-enabled/


    sudo nginx -t -> validar configuración
    sudo tail -f /var/log/nginx/access.log -> log de accesos
    sudo tail -f /var/log/nginx/error.log -> log de errores

## TERRAFORM
- Estructura:
```hcl
/terraform/
├── main.tf            # Archivo principal
├── variables.tf       # Definición de variables
├── provider.tf        # Configuración del provider de Azure
├── terraform.tfvars   # Valores de las variables
├── outputs.tf         # Salidas que exportan valores
├── modules/
│   └── nombre_resource(vnet, vm)/ # Módulo personalizado 
│       ├── main.tf (vnet.tf, vm.tf)
│       └── variables.tf
```

- ### Archivos:
    - modules/vnet/main.tf
    ```hcl
    resource "azurerm_network_security_group" "net_sec_group" {
      name                = var.net_sec_group_name
      location            = var.location
      resource_group_name = var.rg_name
    }

    resource "azurerm_virtual_network" "vnet" {
      name                = var.vnet_name
      location            = var.location
      resource_group_name = var.rg_name
      address_space       = var.address_space
      #dns_servers         = ["10.0.0.4", "10.0.0.5"]

      subnet {
        name             = var.subnet_name_sub1
        address_prefixes = var.subnet_address_prefixes_sub1
      }

      subnet {
        name             = var.subnet_name_sub2
        address_prefixes = var.subnet_address_prefixes_sub2
        security_group   = azurerm_network_security_group.net_sec_group.id
      }

      tags = {
        environment =  var.vnet_tag_env
      }
    }
    ```
    - modules/vnet/variables.tf
    ```hcl
    variable "location" {
      description = "Ubicación del resource group"
      type        = string
    }

    variable "rg_name" {
      description = "Nombre del resource group"
      type        = string
    }

    variable "net_sec_group_name" {
      description = "Nombre del network security group"
      type        = string
    }

    variable "vnet_name" {
      description = "Nombre de la virtual network"
      type        = string
    }

    variable "vnet_tag_env" {
      description = "Tag de la virtual network"
      type        = string
    }

    variable "address_space" {
      type        = list(string)
      description = "The address space to be used for the Virtual Network"
      default     = ["10.1.0.0/16"]
    }

    variable "subnet_name_sub1" {
      description = "Nombre de la subnet"
      type        = string
    }

    variable "subnet_name_sub2" {
      description = "Nombre de la subnet"
      type        = string
    }

    variable "subnet_address_prefixes_sub1" {
      type        = list(string)
      description = "The address prefixes to use for the Subnet"
      default     = ["10.1.1.0/24"]
    }

    variable "subnet_address_prefixes_sub2" {
      type        = list(string)
      description = "The address prefixes to use for the Subnet"
      default     = ["10.1.2.0/24"]
    }
    ```
    ### Archivos para consumir el modulo

    - Provider.tf (se agrega tambien sección para el backend del tfstate)
    ```hcl
    terraform {
      required_providers {
        azurerm = {
          source  = "hashicorp/azurerm"
          version = "=4.1.0"
        }
      }
      backend "azurerm" {
          resource_group_name  = "tfstate"
          storage_account_name = "<storage_account_name>"
          container_name       = "tfstate"
          key                  = "terraform.tfstate"
      }
    }

    # Configure the Microsoft Azure Provider
    provider "azurerm" {
      features {}

      subscription_id = "bb0a3514-f603-494e-bcac-2a2d6395ae56"
    }
    ```   
    - main.tf
    ```hcl
    resource "azurerm_resource_group" "example" {
      name     = var.resource_group_name
      location = var.location
      tags     = var.tags
    }

    module "networking" {
      source = "./modules/vnet" # Ruta al módulo
      #resource_group_name   = azurerm_resource_group.rg_vnet.name
      location                     = var.location
      rg_name                      = azurerm_resource_group.rg_vnet.name
      vnet_name                    = "vnet-mod"
      subnet_name_sub1             = "subnet_1"
      subnet_name_sub2             = "subnet_2"
      net_sec_group_name           = "sec_group_nombre"
      vnet_tag_env                 = "dev"
      address_space                = ["10.1.0.0/16"]
      subnet_address_prefixes_sub1 = ["10.1.1.0/24"]
      subnet_address_prefixes_sub2 = ["10.1.2.0/24"]
    }

    resource "azurerm_resource_group" "rg_vnet" {
      name     = var.rg_vnet_name
      location = var.location
    }
    ```
    - variables.tf
    ```hcl
    variable "resource_group_name" {
      description = "El nombre del grupo de recursos a crear."
      type        = string
    }

    variable "location" {
      description = "La ubicación donde se creará el grupo de recursos."
      type        = string
    }

    variable "tags" {
      description = "Etiquetas opcionales para aplicar al grupo de recursos."
      type        = map(string)
      default = {
        environment = "Dev"
        team        = "IT"
      }
    }

    variable "rg_vnet_name" {
      description = "Nombre del resource group"
      type        = string
    }
    ```
    - terraform.tfvars
    ```hcl
    resource_group_name = "resource_group_terraform"
    location            = "West Europe"
    tags = {
      environment = "Production"
      owner       = "Equipo DevOps"
    }
    rg_vnet_name = "resource_group_vnet"
    ```
    - outputs.tf
    ```hcl
    output "resource_group_name" {
      description = "El nombre del grupo de recursos."
      value       = azurerm_resource_group.example.name
    }

    output "resource_group_location" {
      description = "La ubicación del grupo de recursos."
      value       = azurerm_resource_group.example.location
    }
    ```
## TERRAFORM COMANDOS
```
- terraform init
    -upgrade : fuerza la descarga de nuevas versiones de los proveedores
    -backend=false : deshabilita la config del backend

- terraform plan
    -out=infra_dev.tfplan: guarda el plan para aplicarlo en el apply
    -var 'key=Value': especifica variables desde la linea de comandos
    -destroy: muestra el plan para destruir la infra

- terraform apply -> terraform lee automaticamente todos los archivos .tf  del directorio
    terraform apply infra_dev.tfplan
    -auto-approve: aplica los cambios sin confirmación
    -var-file="variables.tfvars" : Especifica archivo de variables
    -target:

- terraform destroy
    -auto-approve: destruye sin pedir confirmación
    -target: destruye recursos en especifico

- terraform fmt
    -recursive: formatea archivos en subdirectorios

- terraform validate
 
- terraform output
    -json: devuelve resultados en formato json
    terraform output resource_group_location: obtienes el valor de un output en especifico en este caso el de 'resource_group_location'
    
- terraform import:  Importa recursos existentes a la configuración de Terraform
    necesitas la definicion del recurso vacio
    terraform import aws_instance.server-web i-0283838238238238bb
    terraform state show aws_instance.server-web

- terraform state list/rm -> lista los recursos en el estado actual, rm elimina un recurso del estado
- terraform show -> Muestra el estado o el plan de Terraform en un formato legible para que puedas ver los recursos y su configuración actual.
- terraform workspace
```

## TERRAFORM BUENAS PRACTICAS
- Coloca los valores sensibles, como claves API o contraseñas, en archivos .tfvars, y asegúrate de que no se incluyan en tu control de versiones (.gitignore )
- Usa la propiedad depends_on para especificar dependencias explícitas entre recursos, asegurando que Terraform cree los recursos en el orden correcto.
- Usa local variables para evitar la repetición de valores o cálculos complejos en múltiples lugares dentro de un archivo de Terraform.
  ```hcl
    locals {
    resource_group_name = "${var.environment}-rg"
    }

    resource "azurerm_resource_group" "example" {
    name     = local.resource_group_name
    location = "East US"
    }
  ```
- Configura políticas de acceso (crear service principal con los minimos privilegios posibles)
- terraform state replace-provider -auto-approve 'registry.terraform.io/-/azurerm' 'registry.terraform.io/hashicorp/azurerm'
  terraform state replace-provider -auto-approve 'registry.terraform.io/-/azurerm' 'registry.terraform.io/hashicorp/azurerm'
  terraformer import azure -r virtual_machine
  terrafy y terraformer

## TERRAFORM CLOUD
- Estructura:
  - Organización: Normalmente es el nombre de la empresa
  - Workspaces: "workspace" es una unidad de ejecución de Terraform
    - variable, tfstates, Runs (Historial de plan/apply)
    - nombre: dev-infra , qa-infra
  - Projects (Agrupan workspaces)
    - Proyecto A (DEV + QA + PROD WORKSPACES)
  
  ### Los 3 tipos de Workflow de Workspace:
  - version Control Workflow (Flujo automatizado con git):
    - Cada vez que haces git push, se detecta cambios y se ejecuta terraform plan.
    - Se conecta a un repositorio de GitHub
  - CLI-Driven Workflow (solo para guardar .tfstate):
    - almacenar el tfstate y registrar los planes/applies
    - procesamiento local
  - API-Driven Workflow (más avanzado):
    - Interactúas programáticamente usando API REST de Terraform Cloud
    - Muy útil si tienes pipelines externos (hablan directamente con Terraform Cloud para disparar planes y applies)

  ### Qué guarda exactamente un Workspace por dentro
  - .tfstate
  - variables de entorno y secretos (similares a .tfstate)
  - historial de runs
  - outputs
  - locks


-----------------------------
