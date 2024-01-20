provider "google" {
  alias = "token"
}

provider "google-beta" {}

data "google_project" "current" {
  provider   = google.token
  project_id = var.project
}

data "google_service_account_access_token" "default" {
  provider               = google.token
  target_service_account = "terraform@${var.project}.iam.gserviceaccount.com"
  scopes                 = ["cloud-platform"]
  lifetime               = "1200s"
}

provider "google" {
  project      = var.project
  region       = var.region
  access_token = data.google_service_account_access_token.default.access_token
}

module "boilerplate" {
  source      = "../../boilerplate"
  region      = var.region
  project     = var.project
  environment = var.environment
}
