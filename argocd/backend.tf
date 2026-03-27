terraform {
  backend "s3" {
    bucket = "terraform-tfstate-storez"
    key    = "argocd.tfstate"
    region = "ap-south-1"
  }
}