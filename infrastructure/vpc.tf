resource "aws_vpc" "emr-vpc" {
  cidr_block           = "10.0.0.0/16"
  