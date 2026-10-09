# Wrapper root module (this lab's own file, not upstream's): applies upstream's two free modules
# (app/modules/free-resources/privesc-paths and tool-testing) exactly as upstream's app/main.tf
# does, with three differences: the provider takes the credentials from the environment (Isoloom
# passes the AWS CLI session) instead of a named profile, every resource is tagged, and the
# outputs tell the player where to start. The non-free modules stay off, as upstream ships them.
terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 6.0" }
  }
}

variable "region" {
  type    = string
  default = "us-east-1"
}

provider "aws" {
  region = var.region
  default_tags {
    tags = { "isoloom-environment" = "iam-vulnerable", "managed-by" = "isoloom" }
  }
}

data "aws_caller_identity" "current" {}

locals {
  account = data.aws_caller_identity.current.account_id
  # Upstream's rule: every role trusts the principal that deployed the lab.
  deployer = data.aws_caller_identity.current.arn
}

module "privesc-paths" {
  source              = "../app/modules/free-resources/privesc-paths"
  aws_assume_role_arn = local.deployer
  aws_root_user       = format("arn:aws:iam::%s:root", local.account)
}

module "tool-testing" {
  source              = "../app/modules/free-resources/tool-testing"
  aws_assume_role_arn = local.deployer
  aws_root_user       = format("arn:aws:iam::%s:root", local.account)
}

output "account_id" {
  value = local.account
}

output "deployer_arn" {
  description = "The principal every lab role trusts: assume the roles from it."
  value       = local.deployer
}

output "first_role_arn" {
  description = "The role of privesc path 1 (CreateNewPolicyVersion), a first starting point."
  value       = format("arn:aws:iam::%s:role/privesc1-CreateNewPolicyVersion-role", local.account)
  depends_on  = [module.privesc-paths]
}
