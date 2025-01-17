output instance_url {
    description = "Public IP URL of the instance"
    value = "http://${aws_instance.this.public_ip}"
}


output "private_key" {
    description = "SSH Private Key"
    value = tls_private_key.this.private_key_pem
    sensitive = true
}


output "ssh_command" {
    description = "SSH command"
    value = <<-EOF
        tofu output -raw private_key > key.pem
        chmod 0600 key.pem
        ssh -i key.pem ec2-user@${aws_instance.this.public_ip}
    EOF
}