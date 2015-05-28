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

variable "gce_zones" {
  description = "GCE Zones to choose from"
  default = "europe-west1-b,europe-west1-c,europe-west1-d"
}

variable "env" {
  description = "Environment name"
}

variable "ssh_key_path" {
  description = "Path to the ssh key to use"
  default = "ssh/insecure-deployer.pub"
}

variable "user" {
  description = "User account to set up SSH keys for"
  default = "ubuntu"
}

variable "os_image" {
  description = "OS image to boot VMs using"
  default = "ubuntu-1404-trusty-v20150316"
}

variable "network1_cidr" {
  description = "CIDR for network1"
  default     = "10.129.0.0/24"
}

variable "dns_zone_id" {
  description = "Google DNS zone identifier"
  default     = "tsuru2"
}

variable "dns_zone_name" {
  description = "Google DNS zone name"
  default     = "tsuru2.paas.alphagov.co.uk."
}
