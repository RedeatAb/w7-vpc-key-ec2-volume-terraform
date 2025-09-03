// creating s3bucket  
// we lock the state file because we dont want mulitple people 
//making changes to the same file multiple times 



terraform {
  backend "s3" {
    bucket       = "w33k7-practice-123456790"
    key          = "week7/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = false

  }
}
