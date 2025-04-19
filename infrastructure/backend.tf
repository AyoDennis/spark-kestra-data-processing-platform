terraform {
  backend "s3" {
    bucket = "kestra-data-processing-platform-state"
    key    = "module_test/terraform.tfstate"
    region = "us-east-1"
    profile = "personal"
  }
}
