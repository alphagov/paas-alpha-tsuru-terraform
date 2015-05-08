variable "aws_access_key" { 
  description = "AWS access key"
}

variable "aws_secret_key" { 
  description = "AWS secert access key"
}

variable "env" {
  description = "Environment name"
}

variable "region"     { 
  description = "AWS region"
  default     = "eu-west-1"
}

variable "zones" {
  description = "AWS availability zones"
  default     = {
    zone0 = "eu-west-1a"
    zone1 = "eu-west-1b"
  }
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  default     = "10.128.0.0/16"
}

variable "public_cidrs" {
  description = "CIDR for public subnet indexed by AZ"
  default     = {
    zone0 = "10.128.10.0/24"
    zone1 = "10.128.12.0/24"
  }
}

variable "private_cidrs" {
  description = "CIDR for private subnet indexed by AZ"
  default     = {
    zone0 = "10.128.11.0/24"
    zone1 = "10.128.13.0/24"
  }
}

variable "sslproxy_cidrs" {
  description = "CIDR for sslproxy subnet indexed by AZ"
  default     = {
    zone0 = "10.128.15.0/24"
    zone1 = "10.128.17.0/24"
  }
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

variable "api_ssl_certificate_id" {
  description = "SSL Certificate for Tsuru API"
  default = "arn:aws:iam::988997429095:server-certificate/wildcard_tsuru_paas_alphagov" 
}

variable "dns_zone_id_internal" {
  description = "Amazon Route53 DNS zone identifier (internal)"
  default = "Z3OIOPK20MYIOI"
}

variable "dns_zone_id_external" {
  description = "Amazon Route53 DNS zone identifier (external)"
  default = "ZAO40KKT7J2PB"
}

variable "dns_zone_name" {
  description = "Amazon Route53 DNS zone name"
  default     = "tsuru.paas.alphagov.co.uk"
}

variable "registry_s3_bucketname" {
  description = "S3 Object Storage name for the registry"
  default = "mcp.registry.storage"  
}

variable "key_pair_name" {
  description = "SSH Key Pair name to be used to launch EC2 instances"
  default     = "deployer-tsuru-example"
}
