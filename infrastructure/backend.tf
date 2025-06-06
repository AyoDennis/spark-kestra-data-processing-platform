terraform {
  backend "s3" {
    bucket = "spark-kestra-platform"
    key    = "key/terraform.tfstate"
    region = "eu-central-1"
  }
}
