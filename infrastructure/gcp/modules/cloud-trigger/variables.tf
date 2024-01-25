variable "name" {}

variable "description" {}

variable "filename" {
  default = "cloudbuild.yaml"
}

variable "substitutions" {
  type = map(string)
  default = {
    _LOCATION = "europe-west2"
  }
}
variable "branch" {
  default = "main"
}

variable "invert_regex" {
  default = false
}

variable "repository_owner" {
  default = "Jorden-V"
}

variable "repository_name" {
  default = "projects"
}
variable "include" {
  type    = list(string)
  default = ["**"]
}

variable "project" {
  default = ""
}

variable "create_for_dev" {
  type    = bool
  default = true
}

variable "tags" {
  default = []
}
