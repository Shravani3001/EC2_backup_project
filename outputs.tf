output "instance_public_ip" {
    value = aws_instance.backup_ec2.public_ip
}
