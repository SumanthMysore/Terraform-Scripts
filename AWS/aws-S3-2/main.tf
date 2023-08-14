data "aws_s3_bucket" "demo-bucket" {
  bucket = var.s3_bucket_name
}

data "aws_iam_user" "iam_user" {
  user_name = var.iam_user_name
}

resource "aws_s3_bucket_policy" "demo-bucket-policy" {
  bucket = data.aws_s3_bucket.demo-bucket.id
  policy = templatefile("./bucket-policies/full-access.json", {
      "principal" = "${data.aws_iam_user.iam_user.arn}",
      "resource" = "arn:aws:s3:::${data.aws_s3_bucket.demo-bucket.id}/*"
    })
}
