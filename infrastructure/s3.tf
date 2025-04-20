resource "aws_s3_bucket" "s3-input" {
  bucket = "spark-job-data-input"

  tags = {
    Service     = "EMR"
    Environment = "Production"
  }
}

resource "aws_s3_bucket" "s3-output" {
  bucket = "spark-job-data-output"
