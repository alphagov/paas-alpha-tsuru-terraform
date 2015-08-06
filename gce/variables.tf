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

variable "gcs_region" {
  description = "GCS Region to use"
  default = "EU"
}

variable "gce_zones" {
  description = "GCE Zones to choose from"
  default = "europe-west1-b,europe-west1-c,europe-west1-d"
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

variable "coreos_image" {
  description = "coreOS image to deploy our coreOS instances"
  default = "coreos-stable-723-3-0-v20150804"
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

variable "registry_gcs_bucketname" {
  description = "GCS Object Storage name for the registry"
  default = "mcp-registry-storage"
}

variable "registry_gcs_bucketname_acl" {
  description = "GCS Bucket canned Access Control List"
  default = "projectPrivate"
}
