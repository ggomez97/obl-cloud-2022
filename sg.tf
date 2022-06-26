resource "aws_security_group" "sg-bastion" {   # Este recurso nos permite crear el ecurity Group del bastion.   
  name   = "Bastion permit SSH and egress all" # Le asignamos un nombre 
  vpc_id = aws_vpc.main-vpc.id                 # Se le asigna la VPC.
  ingress {                                    
    from_port   = 22                           # Se permite el ingreso detrafico entrante del protocolo SSH desde el puerto 22 al puerto 22 desde la red 0.0.0.0/0
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
 
  egress {                                     # Se permite el egreso de trafico saliente desde cualquier puerto a cualquier puerto de cualquier protocolo desde cualquier IP.
    from_port   = 0                             
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Bastion permit SSH and egress all"
  }
}

resource "aws_security_group" "eks-sg" { # Este recurso nos permite crear el ecurity Group del cluster.
  name        = "eks-sg"
  description = "HTTP from internet"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    description      = "HTTP from internet"   #Dejo sin comentar para hacer pruebas de trafico desde el LB
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]                #IDEA: Solo permitir el ingress desde el LB y egress hacia las 2 subnets.
  }

  egress {                                     #Dejo sin comentar para hacer pruebas de trafico desde el LB
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "eks-sg"
  }
}