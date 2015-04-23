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

variable "ssh_key_path" {
  description = "Path to the ssh key to use"
  default = "../ssh/insecure-deployer.pub"
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
  default     = "10.128.0.0/24"
}

variable "dns_zone_name" {
  description = "Friendly name of DNS zone"
  default     = "tsuru2"
}
