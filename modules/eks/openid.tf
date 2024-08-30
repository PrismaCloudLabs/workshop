resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_tls.certificates.0.sha1_fingerprint]
  url             = aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer
  tags = {
    git_repo  = "sa-lab"
    yor_trace = "afaccb15-9880-4d3d-b032-48177aff51e2"
  }
}