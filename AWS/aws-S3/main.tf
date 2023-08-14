resource "aws_s3_bucket" "demo-bucket" {
  bucket = var.s3_bucket_name
  tags = {
    "Created By"  = var.s3_bucket_tags["Created By"]
    "Description" = var.s3_bucket_tags["Description"]
  }
}

resource "aws_s3_bucket_object" "demo-bucket-object" {
  bucket  = aws_s3_bucket.demo-bucket.id
  count   = length(var.s3_bucket_objects.objects)
  content = var.s3_bucket_objects.objects[count.index]
  key     = var.s3_bucket_objects.keys[count.index]
}

data "aws_iam_user" "terraform_aws_iam_user" {
  user_name = var.iam_user_name
}

resource "aws_s3_bucket_policy" "demo-bucket-policy" {
  bucket = aws_s3_bucket.demo-bucket.id
  policy = templatefile("./bucket-policies/full-access.json", {
      "principal" = "${data.aws_iam_user.terraform_aws_iam_user.arn}",
      "resource" = "arn:aws:s3:::${aws_s3_bucket.demo-bucket.id}/*"
    })
}
