variable "domain_name" {}

variable "acm_certificate_arn" {}

variable "price_class" {
  default = "PriceClass_100"
}

variable "default_root_object" {
  default = "static/index.html"
}

variable "error_response_page_path" {
  default = "/static/index.html"
}
