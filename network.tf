#
#
##Definir si Route 532 es partede network o se dee crear en otro archivo
#
#

resource "aws_vpc" "main-vpc" {
    cidr_block = var.vpc_ip
    
    tags {
        Name= "obl-vpc"
    }  
}

resource "aws_subnet" "private-1a" {
    vpc_id = aws_vpc.main-vpc.id
    cidr_block = var.private-1-ip
    availability_zone = var.zona-1a
  
}

resource "aws_subnet" "private-1b" {
    vpc_id = aws_vpc.main-vpc.id
    cidr_block = var.private-2-ip
    availability_zone = var.zona-1b
  
}

resource "aws_internet_gateway" "obl-gw" {
    vpc_id = aws_vpc.main-vpc.id
    tags = {
      Name = "obl-gateway"
    }
}





