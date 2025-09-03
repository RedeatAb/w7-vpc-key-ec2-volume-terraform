resource "aws_s3_bucket" "example" {
  bucket = "week7-dsg-bucket-redeat"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}