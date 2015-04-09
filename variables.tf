variable "aws_access_key" { 
  description = "AWS access key"
}

variable "aws_secret_key" { 
  description = "AWS secert access key"
}

variable "region"     { 
  description = "AWS region"
  default     = "eu-west-1"
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  default     = "10.128.0.0/16"
}

variable "public_subnet1_cidr" {
  description = "CIDR for public subnet"
  default     = "10.128.0.0/24"
}

variable "public_subnet2_cidr" {
  description = "CIDR for public subnet"
  default     = "10.128.2.0/24"
}

variable "private_subnet1_cidr" {
  description = "CIDR for private subnet 1"
  default     = "10.128.1.0/24"
}

variable "private_subnet2_cidr" {
  description = "CIDR for private subnet 2"
  default     = "10.128.3.0/24"
}

/* Ubuntu 14.04 amis by region */
variable "amis" {
  description = "Base AMI to launch the instances with"
  default = {
    eu-west-1 = "ami-234ecc54"
    eu-central-1 = "ami-9a380b87"
  }
}

variable "nat_ami" {
  description = "Base AMI to launch the NAT instance with"
  default = {
    eu-west-1 = "ami-14913f63"
    eu-central-1 = "ami-a8221fb5"
  }
}
