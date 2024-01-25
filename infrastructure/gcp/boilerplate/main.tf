data "google_project" "current" {}

locals {
  cloud_build_member = "serviceAccount:${data.google_project.current.number}@cloudbuild.gserviceaccount.com"
}

/******************************************
	Service Accounts
 *****************************************/
resource "google_project_iam_member" "cloud_build_perm_1" {
  project = var.project
  role    = "roles/secretmanager.secretAccessor"
  member  = local.cloud_build_member
}
resource "google_project_iam_member" "cloud_build_perm_2" {
  project = var.project
  role    = "roles/iam.serviceAccountUser"
  member  = local.cloud_build_member
}
resource "google_project_iam_member" "cloud_build_perm_3" {
  project = var.project
  role    = "roles/run.admin"
  member  = local.cloud_build_member
}
resource "google_project_iam_member" "cloud_build_perm_4" {
  project = var.project
  role    = "roles/compute.admin"
  member  = local.cloud_build_member
}
resource "google_project_iam_member" "cloud_build_perm_5" {
  project = var.project
  role    = "roles/logging.admin"
  member  = local.cloud_build_member
}
resource "google_project_iam_member" "cloud_build_perm_6" {
  project = var.project
  role    = "roles/storage.admin"
  member  = local.cloud_build_member
}
resource "google_project_iam_member" "cloud_build_perm_7" {
  project = var.project
  role    = "roles/pubsub.admin"
  member  = local.cloud_build_member
}
resource "google_project_iam_member" "cloud_build_perm_8" {
  project = var.project
  role    = "roles/compute.networkAdmin"
  member  = local.cloud_build_member
}

/*****************************************
  Services
 ****************************************/

module "test_service" {
  source           = "../services/test-service"
  project          = var.project
  region           = var.region
  bucket_functions = google_storage_bucket.cloud_function_bucket.name
}

/******************************************
	Cloud Storage
 *****************************************/
resource "google_storage_bucket" "cloud_function_bucket" {
  name     = "functions-${var.project}"
  location = var.region
}

# resource "google_project_organization_policy" "key_creation_allowed" {
#   project    = var.project
#   constraint = "iam.disableServiceAccountKeyCreation"

#   boolean_policy {
#     enforced = false
#   }
# }
