terraform {
  required_version = ">= 1.5.0"
  backend "s3" {
    bucket         = "YOUR-UNIQUE-tfstate-bucket"
    key            = "hello-pipeline/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "YOUR-UNIQUE-tf-locks"
    encrypt        = true
  }
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.50" }
  }
}

provider "aws" {
  region = var.region
}

locals {
  name = "hello-pipeline"
}