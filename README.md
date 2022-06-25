# Obligatorio "Implementacion Soluciones Cloud"

## Propuesta

E-Shop services actualmente cuenta con una arquitectura legacy la cual lo pone en desventaja con su competencia, se contrato la consultora *"BitBeat"* para la modernizar y desplegar la arquitectura e infraestructura de su aplicación que actualmente corre en un datacenter on-premise.

A continuación, se detalla lo antes mencionado:

Diagrama del Monolito:

![Monolito](https://github.com/ggomez97/obl-cloud-2022/blob/develop/online-boutique/docs/img/Monolito.png)

Lista de componentes:
- Un RP para publicar la aplicación
- Dos servidores Web para el Frontend
- Un Servidor web para el control de stock
- Un servidor web para el carrito de compras
- Un servidor web para el catálogo
- Una base de datos relacional
- Un servidor donde se almacenan documentos estáticos
- Una base de datos clave-valor
- Servicios de Cache

## Solucion

Nuestro equipo DevOps realizo la transformación del monolito a una implementación del e-commerce basada en una arquitectura microservicios, esta corre sobre containers cuyo ciclo de integración continua ya se encuentra configurado y la solución se encuentra disponible para ser desplegada de forma automática y desatendida.

Diagrama de arquitectura actual (Micro-Servicios):

![Diagrama](https://github.com/ggomez97/obl-cloud-2022/blob/develop/online-boutique/docs/img/Arquitectura%203.drawio%20(1).png)

Lista de componentes: 

- Servicios AWS Cloud:
  - Virtual Private Cloud
  - Internet gateway
  - EKS (Elastic Kubernetes Service)
  - EC2 Instance
  - Clasic Load Balancer

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

La arquitectura está basada en micro-servicios, los cuales son desplegados en recursos que proporciona AWS.
Utilizamos Docker como tecnología de conteiners, las imágenes están en un repositorio público de DockerHub y estas son utilizadas por Kubernetes que nos permite orquestar el deployment de estos micro-servicios así como nos facilita el monitoreo, administracion y la alta disponibilidad de pods.

Dentro del cluster de EKS tendremos 2 Workes cada uno en una AZ diferente para tener alta disponibilidad en caso de que un AZ tenga fallas.
Creamos y utilizamos un namespace llamado *"online-boutique"* el cual nos brinda la posiblilidad de separar logicamente el cluster y tener nuestros microservicios aislados de los demas.

Para lograr la mayor atuomatizacion posbile optamos por la creacion de una instancia EC2 que es utilizada como bastion.
En esta se instala y configuran todos los prerequisitos de forma desantendia para la utilizacion de Kubernetes, Docker, AWS CLI y con ellos hacer el deployment de nuestros microservicios en diferentes AZ de forma automatizada.

El desarollo del codigo fue gestionado utilizando GitHub que nos da la hablidad de versionado, crear branches y poder trabajar con un workflow mas seguro.
Creamos una branch *"Develop"* la cual fue utilizada para el desarollo del codigo, con el objetivo de poder testear los avances o modificaciones del mismo y asi no arrastrar errores hacia la rama principal *"Main"*. De esta forma nos aseguramos que el codigo en la rama *"Main"* sea el *"Last Known Good".*


