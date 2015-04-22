variable "gce_account_file" {
  description = "JSON Account Credentials file for GCE"
  default = "account.json"
}

variable "gce_project" {
  description = "GCE Project Name to create machines inside of"
  default = "root-unison-859"
}

variable "gce_region" {
  description = "GCE Region to use"
  default = "europe-west1"
}

variable "gce_zone" {
  description = "GCE Zone to use"
  default = "europe-west1-b"
}

variable "user" {
  description = "User account to set up SSH keys for"
  default = "jim"
}

variable "gce_net_name" {
  description = "Name for the network we want"
  default     = "tsuru-tform"
}

variable "gce_net_range" {
  description = "CIDR for network"
  default     = "10.20.30.0/24"
}

variable "public_subnet_cidr" {
  description = "CIDR for public subnet"
  default     = "10.128.0.0/24"
}

variable "private_subnet1_cidr" {
  description = "CIDR for private subnet 1"
  default     = "10.128.1.0/24"
}
