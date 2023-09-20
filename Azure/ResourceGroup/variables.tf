variable "resource_group" {
  type = map(string)
  default = {
    name     = "test-rg"
    location = "East US"
  }
}
