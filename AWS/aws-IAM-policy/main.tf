data "aws_iam_user" "created_user" {
  user_name = var.iam_user_name
}

resource "aws_iam_policy" "admin-access" {
  name = var.iam_policy_name
  tags = {
    "Created By"  = var.iam_policy_tags["Created By"]
    "Description" = var.iam_policy_tags["Description"]
  }
  policy = file("./iam-policies/admin-access-policy.json")
}

resource "aws_iam_user_policy_attachment" "SumanthMysore-terraform-admin-access" {
  user       = data.aws_iam_user.created_user.user_name
  policy_arn = aws_iam_policy.admin-access.arn
}
