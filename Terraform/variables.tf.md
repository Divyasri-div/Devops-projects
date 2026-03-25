variable "region" {
  default = "ap-south-1"
}

variable "ami" {
  default = "ami-0f58b397bc5c1f2e8" # Amazon Linux 2 (Mumbai)
}

variable "instance_type" {
  default = "t2.micro"
}