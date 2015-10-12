provider "google" {
  account_file = "${file("account.json")}"
  project = "${var.gce_project}"
  region = "${var.gce_region}"
}

