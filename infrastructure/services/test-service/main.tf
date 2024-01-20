data "google_compute_default_service_account" "default" {}
locals {
  service_name = "test-service"
}

/******************************************
	Cloud functions
 *****************************************/

module "cloud_function_test_service" {
  source                = "../../../modules/cloud-function"
  function_name         = "test-service"
  function_type         = "node"
  function_description  = "tests"
  environment           = var.environment
  region                = var.region
  service_name          = local.service_name
  function_path         = "services/test/${local.service_name}"
  bucket_functions      = var.bucket_functions
  trigger_substitutions = {}
  trigger_http          = true
  threshold_value       = 0
}