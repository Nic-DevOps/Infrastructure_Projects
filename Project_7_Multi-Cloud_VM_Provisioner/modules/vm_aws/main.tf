resource "aws_instance" "vm" {
  count         = var.instance_count
  ami           = "ami-0c55b159cbfafe1f0" # Replace with region-specific AMI
  instance_type = "t2.micro"

  tags = {
    Name = "aws-vm-${count.index}"
  }
}
