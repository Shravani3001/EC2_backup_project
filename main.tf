provider "aws" {
    region = var.region
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "public_assoc" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public_rt.id
}

data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["099720109477"]

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
}

resource "aws_key_pair" "backup_key" {
    key_name  = "backup_key"
    public_key = file(var.public_key_path)
}

resource "aws_security_group" "ssh_sg" {
    name        = "allow ssh"
    description = "Allow SSH access"
    vpc_id      = aws_vpc.main.id
    
    ingress {
        description = "SSH from anywhere"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "backup_ec2" {
    ami                    = data.aws_ami.ubuntu.id
    instance_type          = var.instance_type
    key_name               = aws_key_pair.backup_key.key_name
    vpc_security_group_ids = [aws_security_group.ssh_sg.id]
    subnet_id              = aws_subnet.public.id
    associate_public_ip_address = true
    
    tags = {
        Name = "BackupEC2"
    }
}
