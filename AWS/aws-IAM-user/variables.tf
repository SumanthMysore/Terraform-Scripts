variable "iam_user_name" {
  default = "SumanthMysore-terraform"
}

variable "iam_user_tags" {
  default = {
    "Created By"  = "Sumanth Mysore"
    "Description" = "IAM User created using terraform script."
  }
}