data "google_project" "current" {}

locals {
  default_substitution_vars = {
    _SERVICE_NAME  = var.service_name,
    _FUNCTION_NAME = var.function_name,
    _FUNCTION_PATH = var.function_path == "" ? "services/${var.service_name}/functions/${var.function_name}" : var.function_path
    _LOCATION      = var.region
  }

  // Default values for each cloud function language.
  // These are chosen by the 'function_type' variable.
  language_config = {
    node = {
      source_archive_object_name   = "node-default.zip"
      source_archive_object_source = "../../utils/default-node-function/default.zip"
      default_entry_point          = "helloWorld"
      default_runtime              = "nodejs20"
    }
    go = {
      source_archive_object_name   = "go-default.zip"
      source_archive_object_source = "../../utils/default-go-function/default.zip"
      default_entry_point          = "Entrypoint"
      default_runtime              = "go119"
    }
  }[var.function_type]
}

/******************************************
	Cloud Storage Object
 *****************************************/

resource "google_storage_bucket_object" "cloud_functions_bucket_archive" {
  name   = var.function_source_archive_object != "" ? var.function_source_archive_object : local.language_config.source_archive_object_name
  bucket = var.bucket_functions
  source = local.language_config.source_archive_object_source
}

/******************************************
	Default Function
  Will be replaced by the one deployed via cloudbuild.yaml (ignore_changes = all)
 *****************************************/

resource "google_cloudfunctions_function" "function" {
  name                  = var.function_name
  description           = var.function_description
  runtime               = var.function_runtime != "" ? var.function_runtime : local.language_config.default_runtime
  service_account_email = var.service_account_email != "" ? var.service_account_email : "${data.google_project.current.project_id}@appspot.gserviceaccount.com"
  available_memory_mb   = var.available_memory_mb
  source_archive_bucket = var.bucket_functions
  source_archive_object = google_storage_bucket_object.cloud_functions_bucket_archive.name
  trigger_http          = var.trigger_http
  dynamic "event_trigger" {
    for_each = var.event_trigger == null ? [] : [var.event_trigger]
    content {
      event_type = event_trigger.value["event_type"]
      resource   = event_trigger.value["resource"]
    }
  }
  entry_point = var.function_entry_point != "" ? var.function_entry_point : local.language_config.default_entry_point

  lifecycle {
    ignore_changes = all
  }
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  count          = var.public ? 1 : 0
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

/******************************************
	Triggers
 *****************************************/
module "trigger_provision" {
  name        = "function-${var.function_name}-provision"
  description = "Provision ${var.function_name} Service (CI/CD)"
  source      = "../cloud-trigger"
  filename    = var.function_path == "" ? "services/${var.service_name}/functions/${var.function_name}/cloudbuild.yaml" : "${var.function_path}/cloudbuild.yaml"
  include     = var.function_path == "" ? ["services/${var.service_name}/functions/${var.function_name}/**"] : ["${var.function_path}/**"]
  tags        = ["function"]
  # branch        = var.branching_strategy.provision.branch
  # invert_regex  = var.branching_strategy.provision.invert_regex
  substitutions = merge(local.default_substitution_vars, var.trigger_substitutions)
}
