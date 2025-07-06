variable "region" {
    description  = "AWS region to deploy"
    type         = string
    default      = "us-east-1"
}

variable "instance_type" {
    description = "EC2 instance type"
    type        = string
    default     = "t2.micro"
}

variable "key_name" {
    description  = "Name of the key pair"
    type         = string
    default      = "backup_key"
}

variable "public_key_path" {
    description  = "Path of the SSH public key file"
    type         = string
    default      = "./backup_key.pub"
}