resource "aws_s3_bucket" "meme_bucket" {
  bucket = var.S3_BUCKET_NAME

  tags = {
    Name        = var.S3_BUCKET_NAME
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "public-access" {
  bucket = aws_s3_bucket.meme_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.meme_bucket.id

  depends_on = [
    aws_s3_bucket_public_access_block.public-access
  ]

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"PublicReadandWrite",
      "Effect":"Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource":["arn:aws:s3:::${aws_s3_bucket.meme_bucket.id}/*"]
    }
  ]
}
POLICY

}
