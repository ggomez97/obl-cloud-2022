## CLUSTER
# ** HPA ** Metric server
resource "aws_eks_cluster" "obl-eks-cluster" {
  name     = "obl-eks-cluster"
  role_arn = var.lab-role

  vpc_config {
    subnet_ids = [aws_subnet.publica-1a.id,aws_subnet.publica-1b.id] 
    security_group_ids = [aws_security_group.eks-sg.id]
  }

}

output "endpoint" {
  value = aws_eks_cluster.obl-eks-cluster.endpoint
}

# output "kubeconfig-certificate-authority-data" {
#   value = aws_eks_cluster.obl-eks-cluster.certificate_authority[0].data
# }

## WORKER

resource "aws_eks_node_group" "worker_obl" {
  cluster_name    = aws_eks_cluster.obl-eks-cluster.name
  node_group_name = "worker_obl"
  node_role_arn   = var.lab-role
  subnet_ids      = [aws_subnet.publica-1a.id,aws_subnet.publica-1b.id]
  instance_types = ["t3.medium"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }    
}
