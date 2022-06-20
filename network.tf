#
#
##Definir si Route 532 es partede network o se dee crear en otro archivo
#
#

resource "aws_vpc" "main-vpc" {
  cidr_block           = var.vpc_ip
  enable_dns_support   = true
  enable_dns_hostnames = true
}
#-----------------------------------------------------
# #Subnet publica
# resource "aws_subnet" "subnet-public" {
#   vpc_id                  = aws_vpc.main-vpc.id
#   cidr_block              = var.public_ip
#   availability_zone       = var.zona-1a
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "subnet-public"
#   }

# }

#Permitiendo la ruta default en ir en la GW
resource "aws_default_route_table" "public-rt" {
  default_route_table_id = aws_vpc.main-vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.obl-gw.id
  }
  tags = {
    Name = "public-route-table"
  }
}

#-------------------------------------------------------------
resource "aws_subnet" "publica-1a" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = var.publica-1-ip
  availability_zone = var.zona-1a
  map_public_ip_on_launch = true


  tags = {
    Name = "VPC US-East-1a"
    resource = "kubernetes.io/cluster/obl-eks-cluster"
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

resource "aws_internet_gateway" "obl-gw" {
  vpc_id = aws_vpc.main-vpc.id
  tags = {
    Name = "obl-gateway"
  }
}





