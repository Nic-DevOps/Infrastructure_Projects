###############################################################################
# AWS VM Module – builds a minimal‑cost EC2 instance.                           #
###############################################################################

variable "aws_region" {}
variable "ssh_pub_key" {}
variable "tags" {
  type = map(string)
}

###############################################################################
# Networking – VPC + Subnet                                                   #
###############################################################################

resource "aws_vpc" "vm_vpc" {
  cidr_block = "10.10.0.0/16"
  tags       = merge(var.tags, { Name = "${var.tags.project}-vpc" })
}

resource "aws_subnet" "vm_subnet" {
  vpc_id                  = aws_vpc.vm_vpc.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags                    = merge(var.tags, { Name = "${var.tags.project}-subnet" })
}

resource "aws_internet_gateway" "vm_igw" {
  vpc_id = aws_vpc.vm_vpc.id
  tags   = merge(var.tags, { Name = "${var.tags.project}-igw" })
}

resource "aws_route_table" "vm_rt" {
  vpc_id = aws_vpc.vm_vpc.id
  tags   = merge(var.tags, { Name = "${var.tags.project}-rt" })

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vm_igw.id
  }
}

resource "aws_route_table_association" "vm_rta" {
  subnet_id      = aws_subnet.vm_subnet.id
  route_table_id = aws_route_table.vm_rt.id
}

###############################################################################
# Security Group – allows SSH (22) and optional HTTP (80).                    #
###############################################################################

resource "aws_security_group" "vm_sg" {
  name_prefix = "${var.tags.project}-sg-"
  description = "Security group for single VM lab"
  vpc_id      = aws_vpc.vm_vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 == all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.tags.project}-sg" })
}

###############################################################################
# Key Pair – uses the provided public key string.                              #
###############################################################################

resource "aws_key_pair" "vm_key" {
  key_name   = "${var.tags.project}-key"
  public_key = var.ssh_pub_key
}

###############################################################################
# EC2 Instance                                                                 #
###############################################################################

resource "aws_instance" "vm" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro" # Free‑tier eligible
  subnet_id              = aws_subnet.vm_subnet.id
  vpc_security_group_ids = [aws_security_group.vm_sg.id]
  key_name               = aws_key_pair.vm_key.key_name

  tags = merge(var.tags, { Name = "${var.tags.project}-aws-vm" })
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

###############################################################################
# Outputs                                                                     #
###############################################################################

output "public_ip" {
  value = aws_instance.vm.public_ip
}