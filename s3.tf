terraform {
  backend "s3" {
    bucket         = "coderview-tfstate"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
  }
}
