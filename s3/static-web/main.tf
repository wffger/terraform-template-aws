# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0
resource "aws_s3_bucket" "site" {
  bucket = var.site_domain
  tags = {
    Name  = "wffger"
    Env   = "test"
    Stack = "terraform"
  }
}


resource "aws_s3_bucket_public_access_block" "site" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "page-not-found.jpg"
  }

  routing_rule {
    condition {
      key_prefix_equals = "/abc"
    }
    redirect {
      replace_key_prefix_with = "coming-soon.jpg"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "site" {
  bucket = aws_s3_bucket.site.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "site" {
  bucket = aws_s3_bucket.site.id

  acl = "public-read"
  depends_on = [
    aws_s3_bucket_ownership_controls.site,
    aws_s3_bucket_public_access_block.site
  ]
}

resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          aws_s3_bucket.site.arn,
          "${aws_s3_bucket.site.arn}/*",
        ]
      },
    ]
  })

  depends_on = [
    aws_s3_bucket_public_access_block.site
  ]
}

resource "aws_s3_object" "html" {
  for_each     = fileset("uploads/", "*.html")
  bucket       = aws_s3_bucket.site.id
  key          = each.value
  source       = "uploads/${each.value}"
  content_type = "text/html"
  etag         = filemd5("uploads/${each.value}")
  acl          = "public-read"
  depends_on = [
    aws_s3_bucket_ownership_controls.site
  ]
}

resource "aws_s3_object" "css" {
  for_each     = fileset("uploads/", "*.css")
  bucket       = aws_s3_bucket.site.id
  key          = each.value
  source       = "uploads/${each.value}"
  content_type = "text/css"
  etag         = filemd5("uploads/${each.value}")
  acl          = "public-read"
  depends_on = [
    aws_s3_bucket_ownership_controls.site
  ]
}


resource "aws_s3_object" "jpg" {
  for_each     = fileset("uploads/", "*.jpg")
  bucket       = aws_s3_bucket.site.id
  key          = each.value
  source       = "uploads/${each.value}"
  content_type = "image/jpeg"
  etag         = filemd5("uploads/${each.value}")
  acl          = "public-read"
  depends_on = [
    aws_s3_bucket_ownership_controls.site
  ]
}
