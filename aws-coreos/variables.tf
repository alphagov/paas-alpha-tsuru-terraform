variable "region"     {
  description = "AWS region"
  default     = "eu-west-1"
}

variable "zones" {
  description = "AWS availability zones"
  default     = {
    zone0 = "eu-west-1a"
    zone1 = "eu-west-1b"
    zone2 = "eu-west-1c"
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
    zone2 = "10.128.14.0/24"
  }
}

variable "private_cidrs" {
  description = "CIDR for private subnet indexed by AZ"
  default     = {
    zone0 = "10.128.11.0/24"
    zone1 = "10.128.13.0/24"
    zone2 = "10.128.15.0/24"
  }
}

variable "ubuntu_amis" {
  description = "Base AMI to launch the instances with"
  default = {
    eu-west-1 = "ami-234ecc54"
    eu-central-1 = "ami-9a380b87"
  }
}

variable "coreos_amis" {
  description = "AMIs to launch coreOS instances"
  default = {
    eu-west-1 = "ami-0e104179"
    eu-central-1 = "ami-b8cecaa5"
  }
}

variable "dns_zone_id" {
  description = "Amazon Route53 DNS zone identifier"
  default = "ZAO40KKT7J2PB"
}

variable "dns_zone_name" {
  description = "Amazon Route53 DNS zone name"
  default     = "tsuru.paas.alphagov.co.uk."
}

variable "registry_s3_rolename" {
  description = "IAM role name for docker registry on S3"
  default = "tsuru-docker-registry-s3"
}

variable "registry_s3_bucketname" {
  description = "S3 Object Storage name for the registry"
  default = "mcp.registry.storage"
}

variable "postgres_s3_rolename" {
  description = "IAM role name for postgres on S3"
  default = "postgres-s3"
}

variable "key_pair_name" {
  description = "SSH Key Pair name to be used to launch EC2 instances"
  default     = "deployer-tsuru-example"
}
