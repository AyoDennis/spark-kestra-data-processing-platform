resource "aws_s3_bucket" "s3-input" {
  bucket = "spark-job-data-input"

  tags = {
    Service     = "EMR"
    Environment = "Production"
  }
}

resource "aws_s3_bucket" "s3-output" {
  bucket = "spark-job-data-output"

  tags = {
    Service     = "EMR"
    Environment = "Production"
  }
}

resource "aws_s3_bucket" "s3-logs" {
  bucket = "emr-cluster-spark-logs"

  tags = {
    Service     = "EMR"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_versioning" "s3-input-versioning" {
  bucket = aws_s3_bucket.s3-input.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "s3-output-versioning_example" {
  bucket = aws_s3_bucket.s3-output.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "s3-logs-versioning_example" {
  bucket = aws_s3_bucket.s3-logs.id
  