resource "aws_eks_cluster" "obl-eks-cluster" { # Este recurso nos permite crear un cluster llamado obl-eks-cluster en AWS.
  name     = "obl-eks-cluster"  
  role_arn = var.lab-role                      # Por medio de una variable le pasamos el rol asignado a mi perfil de AWS academy.

  vpc_config {                                 # Configuramos en que VPC, subnets y security group va a tener el cluster.
    subnet_ids = [aws_subnet.privada-1a.id,aws_subnet.privada-1b.id] 
    security_group_ids = [aws_security_group.eks-sg.id]
  }
}

resource "aws_eks_node_group" "worker_obl" {                            # Este recurso nos permite crear los Workers que tendra el cluster.
  cluster_name    = aws_eks_cluster.obl-eks-cluster.name                # Se le asignan el cluster al cual van a pertenecer los Workers.
  node_group_name = "worker_obl" 
  node_role_arn   = var.lab-role                                        # Por medio de una variable le pasamos el rol asignado a mi perfil de AWS academy.
  subnet_ids      = [aws_subnet.privada-1a.id,aws_subnet.privada-1b.id] # Se le asigna que subnets utilizaran los Workers
  instance_types = ["t3.large"]                                        # Se indica el tipo de instancia que utilizaran los Workers

  scaling_config {                                                      # Se configura el escalado de los Workers con un deseado de 3 maximo de 2 y minimo 2.
                                                                          # de esta forma siempre habran 2 Worker y si es necesario se creara otro Worker.
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }  
}
