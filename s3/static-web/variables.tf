variable "aws_region" {
  type        = string
  description = "The AWS region to put the bucket into"
  default     = "ap-southeast-1"
}

variable "site_domain" {
  type        = string
  description = "The domain name to use for the static site"
  default = "test.wffger.fun"
}

variable "aws_access_key" {
  type = string
  description = "AWS access key"
  sensitive   = true
}
variable "aws_secret_key" {
  type = string
  description = "AWS secret key"
  sensitive   = true
}