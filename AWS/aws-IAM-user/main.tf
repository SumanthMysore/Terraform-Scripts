resource "aws_iam_user" "terraform_aws_iam_user" {
  name = var.iam_user_name
  tags = {
    "Created By"  = var.iam_user_tags["Created By"]
    "Description" = var.iam_user_tags["Description"]
  }
}