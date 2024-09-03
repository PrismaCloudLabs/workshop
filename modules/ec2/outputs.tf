output "publicIPs" {
  value = [for v in aws_instance.this : v.public_ip]
}

output "securityGroupIds" {
  value = [for v in aws_security_group.instance_sg : v.id]
}

output "sshKeyName" {
 value = aws_key_pair.kp.key_name
}

output "sshPrivateKey" {
  value     = tls_private_key.pk.private_key_pem
  sensitive = true
}