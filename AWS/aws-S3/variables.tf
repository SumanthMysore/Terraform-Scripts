variable "s3_bucket_name" {
  default = "terraform-s3-bucket-sumanthmysore"
}

variable "s3_bucket_tags" {
  default = {
    "Created By"  = "Sumanth Mysore"
    "Description" = "S3 bucket created using terraform script."
  }
}

variable "s3_bucket_objects" {
  default = {
    objects = ["./objects/car.jpg", "./objects/mountain.jpg"]
    keys    = ["car-image.jpg", "mountain-image.jpg"]
  }
}

variable "iam_user_name" {
  default = "SumanthMysore-terraform"
}
