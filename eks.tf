## CLUSTER

resource "aws_eks_cluster" "cluster_obl" {
  name     = "cluster_obl"
  role_arn = aws_iam_role.cluster_obl_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.private-1a.id,aws_subnet.private-1b.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_obl_role-AmazonEKSClusterPolicy,
  ]
}

output "endpoint" {
  value = aws_eks_cluster.cluster_obl.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.cluster_obl.certificate_authority[0].data
}

## WORKER

resource "aws_eks_node_group" "worker_obl" {
  cluster_name    = aws_eks_cluster.cluster_obl.name
  node_group_name = "worker_obl"
  node_role_arn   = aws_iam_role.worker_obl_role.arn
  subnet_ids      = [aws_subnet.private-1a.id,aws_subnet.private-1b.id]
  instance_types = ["t3.medium"]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker_obl_role-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.worker_obl_role-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.worker_obl_role-AmazonEC2ContainerRegistryReadOnly,
  ]
}
