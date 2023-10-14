provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "myvm" {
    ami = "ami-0fa3d3dafc154a053" # AMZ linux 2023 arm64
    subnet_id = "subnet-9f7267d6" # us-east-1a
    instance_type = "a1.medium"
    tags = {
        Name = "my-first-tf-vm"
    }
}
