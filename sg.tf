resource "aws_security_group" "sg-bastion" { #Cambiar nombre
  name   = "Permit all"
  vpc_id = aws_vpc.main-vpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Testing-Permit-All"
  }
}