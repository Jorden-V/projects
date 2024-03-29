resource "google_cloudbuild_trigger" "continuous-provisioning-trigger-push" {
  description = var.description
  tags        = var.tags
  name        = var.name
  github {
    owner = var.repository_owner
    name  = var.repository_name
    push {
      branch       = var.branch
      invert_regex = var.invert_regex
    }
  }
  substitutions  = var.substitutions
  filename       = var.filename
  included_files = var.include
}
