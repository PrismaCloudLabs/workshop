# output "publicIP" {
#   value = aws_instance.this.public_ip
# }

output "publicIPs" {
  value = [for v in aws_instance.this : v.public_ip]
}

output "securityGroupIds" {
  value = [for v in aws_security_group.instance_sg : v.id]
}