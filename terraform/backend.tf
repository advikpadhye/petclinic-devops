terraform {
  backend "s3" {
    bucket       = "petclinic-terraform-state-749972934681"
    key          = "petclinic/dev/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
