terraform {
  backend "s3" {
    bucket = "terraform-tfstate-storez"
    key    = "aws-load-balancer-controller.tfstate"
    region = "ap-south-1"
  }
}