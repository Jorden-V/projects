variable "bucket_functions" {}
variable "function_name" {}
variable "function_description" {}
variable "function_path" {
  default = ""
}
variable "service_name" {
  description = "Name of the service wrapping this function (you must have functions folder in it)"
}
variable "trigger_substitutions" {
  description = "Substitution variable for the trigger, think about Buckets names, pubsub names, service accounts, etc. Anything dynamic you will need to deploy this function (via Yaml file)"
}
variable "region" {
  default = "europe-west2"
}
variable "public" {
  type    = bool
  default = false
}
variable "service_account_email" {
  default = ""
}
variable "available_memory_mb" {
  default = "128"
}
variable "trigger_http" {
  default = true
}
variable "event_trigger" {
  description = "event trigger, per resource docs"
  default     = null
}
variable "function_runtime" {
  default = ""
}

variable "function_entry_point" {
  default = ""
}
variable "function_source_archive_object" {
  default = ""
}
variable "function_type" {}
variable "threshold_value" {
  default = 60
}
