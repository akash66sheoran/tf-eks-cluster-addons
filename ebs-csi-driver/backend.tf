terraform {
  backend "s3" {
    bucket = "terraform-tfstate-storez"
    key    = "ebs-csi-driver.tfstate"
    region = "ap-south-1"
  }
}