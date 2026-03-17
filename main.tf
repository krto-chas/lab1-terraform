# main.tf
terraform {
  backend "gcs" {}

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

locals {
  student_slug = replace(lower(var.student_id), " ", "-")
}

resource "google_compute_instance" "vm" {
  name         = "${local.student_slug}-lab1-vm"
  machine_type = "e2-micro"
  zone         = "${var.region}-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
      type  = "pd-standard"
    }
  }

  network_interface {
    network = "default"
    access_config {} # Ger VM:en en extern IP
  }

  metadata_startup_script = file("startup.sh")

  labels = {
    student = local.student_slug
    course  = "devsecops-2026"
    lab     = "1"
  }

  tags = ["lab1", "ssh"]
}

resource "google_compute_resource_policy" "daily_backup" {
  name   = "${local.student_slug}-daily-backup-v2"
  region = var.region

  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time    = "03:00"
      }
    }
    retention_policy {
      max_retention_days    = 7
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }
  }
}

resource "google_compute_disk_resource_policy_attachment" "backup_attachment" {
  name = google_compute_resource_policy.daily_backup.name
  disk = google_compute_instance.vm.name
  zone = "${var.region}-b"
}