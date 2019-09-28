terraform {
  required_version = ">= 0.11.14"
}

# variable "gcp_credentials" {
#   description = "GCP credentials needed by google provider"
# }

variable "gcp_project" {
  description = "GCP project name"
}

variable "gcp_region" {
  description = "GCP region - e.g. us-west1"
  default     = "us-west1"
}

variable "gcp_zone" {
  description = "GCP zone, e.g. us-east1-a or us-west1-b"
  default     = "us-west1-b"
}

variable "machine_type" {
  description = "GCP machine type"
  default     = "g1-small" # Must be n1-standard-1 or g1-small at start of demo.
}

variable "instance_name" {
  description = "GCP instance name"
  default     = "demo"
}

variable "image" {
  description = "image to build instance from"
  default     = "debian-cloud/debian-9"
}

provider "google" {
  # credentials = "${var.gcp_credentials}"
  project = "${var.gcp_project}"
  region  = "${var.gcp_region}"
}

resource "google_compute_instance" "demo" {
  name                      = "${var.instance_name}"
  machine_type              = "${var.machine_type}"
  zone                      = "${var.gcp_zone}"
  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

}

# Was assigned_nat_ip.
output "external_ip" {
  # value = "${google_compute_instance.demo.network_interface.0.access_config.0.assigned_nat_ip}"
  value = "${google_compute_instance.demo.network_interface.0.access_config.0.nat_ip}"
}
