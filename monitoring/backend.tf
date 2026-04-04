terraform {
  backend "s3" {
    bucket = "terraform-tfstate-storez"
    key    = "monitoring.tfstate"
    region = "ap-south-1"
  }
}