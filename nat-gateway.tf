resource "aws_eip" "eip-nat-gateway-1"{        # Recurso que permite crear un elastic IP que necesitaremos para las NAT Gateway
    depends_on = [aws_internet_gateway.obl-gw] # Agregamos una dependecia ya que necesita estar creada la GW
    vpc= true                                  # Se indica que esta EIP se encuentra en una VPC
    tags={
        Name= "EIP-1"
    }
}

resource "aws_eip" "eip-nat-gateway-2"{         # Recurso que permite crear un elastic IP que necesitaremos para las NAT Gateway
    depends_on = [aws_internet_gateway.obl-gw]  # Agregamos una dependecia ya que necesita estar creada la GW
    vpc= true                                   # Se indica que esta EIP se encuentra en una VPC
    tags={
        Name= "EIP-2"
    }
}

resource "aws_nat_gateway" "nat-gateway-1"{     # Se crea la NAT Gateway para la subnet publica en la AZ us-east-1a 
    depends_on = [aws_subnet.publica-1a]        # Agregamos una dependencia ya que necesita estar creada la subnet
    allocation_id= aws_eip.eip-nat-gateway-1.id # Le indicamos la EIP que tendra este NAT Gateway
    subnet_id= aws_subnet.publica-1a.id         # Se indica en que subnet va a estar la NAT Gateway
    tags={
        Name= "Nat Gateway Public Subnet 1"
    }
}

resource "aws_nat_gateway" "nat-gateway-2"{
    depends_on = [aws_subnet.publica-1b]
    allocation_id= aws_eip.eip-nat-gateway-2.id
    subnet_id= aws_subnet.publica-1b.id
    tags={
        Name= "Nat Gateway Public Subnet 2"
    }
}