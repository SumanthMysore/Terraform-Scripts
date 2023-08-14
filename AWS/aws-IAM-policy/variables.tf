variable "iam_user_name" {
  default = "SumanthMysore-terraform"
}

variable "iam_policy_name" {
  default = "terraform-admin-access-policy"
}

variable "iam_policy_tags" {
  default = {
    "Created By"  = "Sumanth Mysore"
    "Description" = "IAM policy created using terraform script."
  }
}