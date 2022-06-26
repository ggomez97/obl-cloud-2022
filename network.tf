resource "aws_vpc" "main-vpc" { # Recurso que permite la creacion de la VPC utilizada en nuestra infraestructura
  cidr_block           = var.vpc_ip  
  enable_dns_support   = true #Activamos el soporte de DNS en la VPC
  enable_dns_hostnames = true #Activamos el soporte de hostnames DNS en la VPC

  tags= {
    Name= "obl-vpc" # Le asignamos un nombre para poder identificarla.
  }
}

resource "aws_default_route_table" "public-rt" {  #Este recurso permite administrar la "default route table" de la VPC "main-vpc".               
  default_route_table_id = aws_vpc.main-vpc.default_route_table_id #Definimos cual esa la default route table" y la vinculamos con la VPC.
  route {
    cidr_block = "0.0.0.0/0" # Permitimos el trafico proveniente de todas las redes.
    gateway_id = aws_internet_gateway.obl-gw.id # Especificamos que Gateway va a utilizar la routing table.
  }
  tags = {
    Name = "public-route-table" # Le asignamos un nombre para poder identificarla.
  }
}

resource "aws_subnet" "publica-1a" { # Defininimos el recurso que permite la creacion de la subnet "publica-1a"
  vpc_id            = aws_vpc.main-vpc.id # Le asignamos la VPC en la cual va a localizarse
  cidr_block        = var.publica-1-ip # Le asignamos la IP previamente declarada en variable.tfvars
  availability_zone = var.zona-1a # Le asignamos la avaiability zone declarada en variable.tfvars
  map_public_ip_on_launch = true # Le indicamos que cualquier instancia dentro de esta subnet tenga una IP publica 
  tags = {
    Name = "VPC US-East-1a" # Le asignamos un nombre para poder identificar la subnet
    resource = "kubernetes.io/cluster/obl-eks-cluster"  #Le especificamos que esta subnet tiene que ser utilizada por el cluster "obl-eks-cluster"
  }
}

resource "aws_subnet" "publica-1b" {
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = var.publica-2-ip
  availability_zone = var.zona-1b
  map_public_ip_on_launch = true
  tags = {
    Name = "VPC US-East-1b"
    resource = "kubernetes.io/cluster/obl-eks-cluster"
  }
}

resource "aws_internet_gateway" "obl-gw" { # Este recurso permite la creacion del internet gateway que permite la coneccion entre las subnet publicas e internet.
  vpc_id = aws_vpc.main-vpc.id # Le especificamos que la VPC a utilizar es "main-vpc"
  tags = {
    Name = "obl-gateway" #Le asignamos un nombre para poder identificar la IG
  }
}