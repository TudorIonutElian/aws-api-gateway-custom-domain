/**********************************************************
  # Configure the AWS Provider
  # Add configuration to authorisation keys
*/
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

/**********************************************************
  # Add configuration to authorisation keys
  # Configure the AWS Provider  
**********************************************************/

provider "aws" {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
}