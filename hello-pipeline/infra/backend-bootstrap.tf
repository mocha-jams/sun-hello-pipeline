resource "aws_s3_bucket" "tfstate" {
  bucket = "YOUR-UNIQUE-tfstate-bucket"
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_dynamodb_table" "tflock" {
  name         = "YOUR-UNIQUE-tf-locks"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute { name = "LockID" type = "S" }
}