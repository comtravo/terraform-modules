variable "lambda_file_name" {
  type        = string
  description = "AWS Lambda zip file name during terraforming"
}
variable "lambda_name" {
  type        = string
  description = "AWS Lambda name"
}

variable "lambda_source_code_hash" {
  type        = string
  description = "AWS Lambda source code hash"
}

variable "release" {
  type        = string
  description = "Docker Tag to release"
}

variable "enable" {
  default     = false
  type        = bool
  description = "Enable module"
}
