terraform {
  backend "s3" {
    bucket = "terraform-tfstate-storez"
    key    = "observability.tfstate"
    region = "ap-south-1"
  }
}