# Obligatorio "Implementacion Soluciones Cloud"

## Propuesta

E-Shop services actualmente cuenta con una arquitectura legacy la cual lo pone en desventaja con su competencia, se contrato la consultora *"BitBeat"* la cual somos parte del equipo DevOps para la modernizar y desplegar la arquitectura e infraestructura de su aplicación de forma automatizada y desatendida, que actualmente corre en un datacenter on-premise.

A continuación, se detalla lo antes mencionado:

Diagrama del Monolito:

![Monolito](https://github.com/ggomez97/obl-cloud-2022/blob/develop/online-boutique/docs/img/Monolito.png)

Lista de componentes:
- Un RP para publicar la aplicación.
- Dos servidores Web para el Frontend.
- Un Servidor web para el control de stock.
- Un servidor web para el carrito de compras.
- Un servidor web para el catálogo.
- Una base de datos relacional.
- Un servidor donde se almacenan documentos estáticos.
- Una base de datos clave-valor.
- Servicios de Cache.

## Solucion

Nuestro equipo DevOps realizo la transformación del monolito a una implementación del e-commerce basada en una arquitectura microservicios alojados en containers y luego desplegados en Kubernetes cuyo ciclo de integración continua ya se encuentra configurado, la solución se encuentra disponible para ser desplegada de forma automática y desatendida.

Diagrama de arquitectura actual (Micro-Servicios):

![Diagrama](https://github.com/ggomez97/obl-cloud-2022/blob/main/online-boutique/docs/img/Arquitectura.jpg)

Lista de componentes: 

- Servicios AWS Cloud:
  - Virtual Private Cloud
  - Internet gateway
  - EKS (Elastic Kubernetes Service)
  - EC2 Instance
  - Clasic Load Balancer
  - NAT Gateway (Public)
  - Virtual Private Cloud

- Repositorios:
  - GitHub
  - DockerHub

- Tecnologias y herramientas utilizadas:
  - Docker
  - Kubernetes
  - Terraform
  - Bash
  - GitHub
  - Drawio

La arquitectura está basada en micro-servicios, los cuales son desplegados en recursos que proporciona AWS. Utilizamos Docker como tecnología de conteiners, las imágenes de estos están en un repositorio público de DockerHub y son utilizadas por Kubernetes que nos permite orquestar el deployment de estos micro-servicios así como nos facilita el monitoreo, administracion y la alta disponibilidad de los mismos.

Nuestro cluster de EKS se encuentra en 2 subnet privadas en las cuales tendremos 2 Workes cada uno en una AZ diferente para tener alta disponibilidad en caso de que un AZ tenga fallas. Creamos y utilizamos un namespace llamado "online-boutique" el cual nos brinda la posibilidad de separar lógicamente el cluster y tener nuestros microservicios aislados de los demás.
Al tener los Workers en subnets privadas estos no tienen conexion a internet, por esto implementamos 2 NAT Gateway publicos los cuales permiten que los recursos en las subnets privadas tengan salida a Internet pero que restrigne la entrada de trafico no permitido desde Internet.
Como utilizamos NAT Gateway es necesario utilziar *"Route Tables"* para direccionar el trafico entre subnets.
Se crearon 2 *"Route Tables"* para las subnet privadas (una para cada subnet privada) las cuales dirigen el tafico hacia sus respectivas NAT Gateways y para las subnet publicas se creo una *"Route Tables"* que fue asociada a las mismas dirigiendo el trafico hacia el *"Internet Gateway"*.
Mediante la utilizacion de *"Security Groups"* solo permitimos al EKS la entrada desde internet por el puerto 80 y el egreso de trafico desde cualquier protocolo/puerto hacia cualquier red. Para el *"Bastion"* solo permitimos la entrada del puerto 22 protocolo TCP.


Para lograr la mayor automatización posible optamos por la creación de una instancia EC2 que es utilizada como bastión que se encuentra en una de las subnets puiblicas. En esta se instala y configuran todos los prerrequisitos de forma desatendida para la utilización de Kubernetes, Docker, AWS CLI y con ellos hacer el deployment de nuestros microservicios en los diferentes Workers de forma automatizada.

El desarrollo del código fue gestionado utilizando GitHub que nos da la habilidad de versionado, crear branches y poder trabajar con un workflow mas seguro. Creamos una branch "Develop" la cual fue utilizada para el desarrollo del código, con el objetivo de poder testear los avances o modificaciones del mismo y así no arrastrar errores hacia la rama principal "Main". De esta forma nos aseguramos que el código en la rama "Main" sea el "Last Known Good".

## Mejoras a futuro

En esta sección hablaremos de mejoras en la implementación que se pueden realizar a futuro para un mejor manejo de fallos.

- ### ABL (Aplication Load Balancer)

Actualmente el servicio de Load Balancer es creado de forma declarativa por Kubernetes en AWS mediante el archivo .yaml del deployment "Frontend", este load balancer es del tipo "Classic". Esta mejora se debe a que el ABL solo balancea los protocolos HTTP y HTTPS de la aplicación, lo cual mitiga riesgos de exponer protocolos o puertos no deseados a internet además de que el servicio de AWS "Clasic Load Balancer" está siendo deprecado por lo que de acá a unos meses no será posible utilizarlo.

- ### HPA (Horizontal Pod Autoscaling)

Utilizando HPA podemos darle elasticidad, en segundos y de forma automatizada a nuestros PODs en los momentos que  estén sobrecargándose.
Para esto debemos determinar en qué porcentaje de uso de nuestros PODs debe actuar el escalado.

## Guia de uso

- ### Prerrequisitos en el host

- Tener instalado:
  - Terraform (v1.1.8)
  - Git (v2.25.1) 

- ### Pequeñas configuraciones para el uso de la implementación desarrollada.

Al utilizar AWS como provider para realizar la implementación desarrollada es necesario cambiar ciertos valores de las variables declaradas en el archivo variable.tfvars.

Se tendrá que cambiar las siguientes líneas: 

- *"Region"*: Dependiendo en que región se desea levantar la infraestructura desarrollada se tiene que cambiar este valor por el deseado.
- *"Access"*: Se deberá llenar con la clave de acceso de su usuario.
- *"Secret"*: Se deberá llenar con la clave secret de su usuario.
- *"Token"*: Se deberá llenar con la clave del token de su usuario.
- *"ssh-key"*: Se deberá cambiar el contenido del a variable por una clave SSH que su usuario tenga creada y descargada en el host donde se ejecutará el terraform apply.
- *"ssh-path"*: Se debe cambiar el contenido de la variable por el path del host en donde se encuentra su clave SSH.
- *"lab-Role"*: Debido a que utilizamos AWS Academy no es posible usar IAM, por esto es necesario cambiar el contenido de la variable por el roll de su usuario.
Lo pude encontrar utilizando la creacion manual de un Cluster desde la web de AWS.

- ### Terraform apply

Con estos simples comandos se realiza toda la creación e instalación de todos recursos necesarios para el funcionamiento de nuestra aplicación de micro-servicos.

```
git clone https://github.com/ggomez97/obl-cloud-2022.git
cd obl-cloud-2022/
terraform init
terraform apply -var-file variable.tfvars
```
