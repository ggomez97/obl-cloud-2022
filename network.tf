# Creamos la VPC

resource "aws_vpc" "main-vpc" { # Recurso que permite la creacion de la VPC utilizada en nuestra infraestructura
  cidr_block           = var.vpc_ip  
  enable_dns_support   = true #Activamos el soporte de DNS en la VPC
  enable_dns_hostnames = true #Activamos el soporte de hostnames DNS en la VPC

  tags= {
    Name= "obl-vpc" # Le asignamos un nombre para poder identificarla.
  }
}

# Creamos las Subnets y las asociamos a sus respectivas RT

resource "aws_subnet" "publica-1a" {      # Defininimos el recurso que permite la creacion de la subnet "publica-1a"
  vpc_id            = aws_vpc.main-vpc.id # Le asignamos la VPC en la cual va a localizarse
  cidr_block        = var.publica-1-ip    # Le asignamos el rango de IP previamente declarada en variable.tfvars
  availability_zone = var.zona-1a         # Le asignamos la avaiability zone declarada en variable.tfvars
  map_public_ip_on_launch = true          # Le indicamos que cualquier instancia dentro de esta subnet tenga una IP publica 
  tags = {
    Name = "Public subnet US-East-1a"     # Le asignamos un nombre para poder identificar la subnet
 }
}

resource "aws_subnet" "publica-1b" {
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = var.publica-2-ip
  availability_zone = var.zona-1b
  map_public_ip_on_launch = true
  tags = {
    Name = "Public subnet US-East-1a"   
  }
}

resource "aws_subnet" "privada-1a" { # Defininimos el recurso que permite la creacion de la subnet "privada-1a"
  vpc_id = aws_vpc.main-vpc.id       # Le asignamos la VPC en la cual va a localizarse
  cidr_block = var.privada-1-ip      # Le asignamos el rango de IP previamente declarada en variable.tfvars
  availability_zone = var.zona-1a    # Le asignamos la avaiability zone declarada en variable.tfvars
  map_public_ip_on_launch = false    # Le indicamos que cualquier instancia dentro de esta subnet no tenga una IP publica 
  tags = {
    Name = "Private subnet US-East-1a"
    resource = "kubernetes.io/cluster/obl-eks-cluster"
  }
}

resource "aws_subnet" "privada-1b" {
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = var.privada-2-ip
  availability_zone = var.zona-1b
  map_public_ip_on_launch = false
  tags = {
    Name = "Private subnet US-East-1b"
    resource = "kubernetes.io/cluster/obl-eks-cluster"
  }
}
resource "aws_route_table" "private-route-table-1" { # Creamos la RT para la subnet privada 1a
  vpc_id=aws_vpc.main-vpc.id                         # Se le indica en que VPC va a actuar

  route {                                            # Indicamos que a cualquier destino se debe routear hacia la NAT Gateway 1
    cidr_block="0.0.0.0/0"
    nat_gateway_id=aws_nat_gateway.nat-gateway-1.id 
  }
  tags={
    Name="Private route table 1"
  }
}
resource "aws_route_table_association" "private-subnet-1-route-table-association"{ # Asociamos la RT previamente creada a la subnet privada en la AZ us-east-1a
  subnet_id=aws_subnet.privada-1a.id
  route_table_id=aws_route_table.private-route-table-1.id

}
resource "aws_route_table" "private-route-table-2" {
  vpc_id=aws_vpc.main-vpc.id

  route {
    cidr_block="0.0.0.0/0"
    nat_gateway_id=aws_nat_gateway.nat-gateway-2.id
  }
  tags={
    Name="Private route table 2"
  }
}

resource "aws_route_table_association" "private-subnet-2-route-table-association"{
  subnet_id=aws_subnet.privada-1b.id
  route_table_id=aws_route_table.private-route-table-2.id
}
resource "aws_route_table" "public-route-table" {  # Creamos la RT para las subnet publicas
  vpc_id=aws_vpc.main-vpc.id

  route {
    cidr_block="0.0.0.0/0"
    gateway_id = aws_internet_gateway.obl-gw.id    # Para esta RT utilizaremos cono GW la GW "obl-gw"
  }  
  tags={
    Name="Public route table"
  }
}

resource "aws_route_table_association" "public-subnet-1-route-table-association"{  # Asociamos ambas subnets publicas a la RT publica
  subnet_id=aws_subnet.publica-1a.id
  route_table_id=aws_route_table.public-route-table.id
}
resource "aws_route_table_association" "public-subnet-2-route-table-association"{
  subnet_id=aws_subnet.publica-1b.id
  route_table_id=aws_route_table.public-route-table.id
}

# Creacion de IGW

resource "aws_internet_gateway" "obl-gw" { # Este recurso permite la creacion del internet gateway que permite la coneccion entre las subnet publicas e internet.
  vpc_id = aws_vpc.main-vpc.id # Le especificamos que la VPC a utilizar es "main-vpc"
  tags = {
    Name = "obl-gateway" #Le asignamos un nombre para poder identificar la IG
  }
}