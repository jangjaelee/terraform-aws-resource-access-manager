# AWS Resource Access Manager Terraform module

Terraform module which creates Transit Gateway resources on AWS.

These types of resources are supported:

* [Resource Access Manager Share](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share)
* [Resource Access Manager Principal Association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association)
* [Resource Access Manager Association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association)
* [Resource Access Manager Share Accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share_accepter)


## Usage
### `Create Resource Access Manager - shared by me`
`main.tf`
```hcl
module "ram" {
  source = "git@github.com:jangjaelee/terraform-aws-resource-access-manager.git"

  account_id = var.account_id
  region     = var.region
  prefix     = var.prefix
  tags       = var.tags

  create_ram = var.create_ram
  ram_name   = var.ram_name
  
  allow_external_principals = var.allow_external_principals
  resource_arn              = data.aws_ec2_transit_gateway.this.arn
  ram_principals            = var.ram_principals
}
```
---

`provider.tf`
```hcl
provider  "aws" {
  region  =  var.region
  allowed_account_ids = var.account_id
  #shared_credentials_file = "~/.aws/credentials"
  profile = "default"

  #assume_role {
    #role_arn     = "arn:aws:iam::123456789012:role/test"
    #session_name = "test"
    #external_id  = "EXTERNAL_ID"
  #}
}
```
---

`terraform.tf`
```hcl
terraform {
  required_version = ">= 1.1.3"
  
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.72"
    }
  }

  backend "s3" {
    bucket = "kubesphere-terraform-state-backend" # S3 bucket 이름 변경(필요 시)
    key = "kubesphere/ram-shared-by-me/terraform.state"
    region = "ap-northeast-2"
    dynamodb_table = "kubesphere-terraform-state-locks" # 다이나모 테이블 이름 변경(필요 시)
    encrypt = true
    profile = "default"
  }
}
```
---

`variables.tf`
```hcl
variable "region" {
  description = "List of Allowed AWS account IDs"
  type        = string
}

variable "account_id" {
  description = "Allowed AWS account IDs"
  type        = list(string)
}

variable "prefix" {
  description = "prefix for aws resources and tags"
  type        = string
}

variable "tags" {
  description = "tag map"
  type        = map(string)
}

variable "create_ram" {
  description = "Controls if Resource Access Manager should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "ram_name" {
  description = "The name of the resource share"
  type        = string
}

variable "allow_external_principals" {
  description = "Indicates whether principals outside your organization can be associated with a resource share"
  type        = bool
  default     = true
}

variable "tgw_name" {
  description = "Name to be used on all the resources as identifier for Transit Gateway"
  type        = string
}

variable "ram_principals" {
  description = "The principal to associate with the resource share. Possible values are an AWS account ID, an AWS Organizations Organization ARN, or an AWS Organizations Organization Unit ARN"
  type        = list(string)
}
```
---

`terraform.tfvars`
```hcl
region      = "ap-northeast-2"
account_id  = ["098765432109"]
prefix      = "dev"

create_ram                = true
ram_name                  = "jjlee"
allow_external_principals = true
tgw_name                  = "jjlee"
ram_principals            = ["123456789012"]

tags = {
    "CreatedByTerraform" = "true"
    "TerraformModuleName" = "terraform-aws-module-resource-access-manager"
    "TeffaformModuleVersion" = "v1.0.0"
}
```
---

`outputs.tf`
```hcl
output "ram_resource_share_id" {
  value = module.ram.ram_resource_share_id
}

output "ram_resource_share_tags_all" {
  value = module.ram.ram_resource_share_tags_all
}
```
---

`data.tf`
```hcl
data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_ec2_transit_gateway" "this" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-${var.tgw_name}-tgw"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}
```
---

### `Create Resource Access Manager - shared with me`

`main.tf`
```hcl
module "ram-shared-with-me" {
  source = "git@github.com:jangjaelee/terraform-aws-resource-access-manager.git"

  account_id = var.account_id
  region     = var.region
  prefix     = var.prefix
  tags       = var.tags

  create_ram             = var.create_ram  
  share_accepter         = true
  ram_resource_share_arn = var.ram_resource_share_arn
}
```
---

`provider.tf`
```hcl
provider "aws" {
  region = var.region
  allowed_account_ids = var.account_id
  shared_credentials_file = "~/.aws/credentials"
  profile = "true_friend"

  assume_role {
    role_arn     = "arn:aws:iam::123456789012:role/test"
    #session_name = "test"
    #external_id  = "EXTERNAL_ID"
  }  
}
```
---

`terraform.tf`
```hcl
terraform {
  required_version = ">= 1.1.3"
  
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.72"
    }
  }

  backend "s3" {
    bucket = "kubesphere-terraform-state-backend" # S3 bucket 이름 변경(필요 시)
    key = "kubesphere/ram-shared-with-me/terraform.state"
    region = "ap-northeast-2"
    dynamodb_table = "kubesphere-terraform-state-locks" # 다이나모 테이블 이름 변경(필요 시)
    encrypt = true
    profile = "default"
  }
}
```
---

`variables.tf`
```hcl
variable "region" {
  description = "List of Allowed AWS account IDs"
  type        = string
}

variable "account_id" {
  description = "Allowed AWS account IDs"
  type        = list(string)
}

variable "prefix" {
  description = "prefix for aws resources and tags"
  type        = string
}

variable "tags" {
  description = "tag map"
  type        = map(string)
}

variable "create_ram" {
  description = "Controls if Resource Access Manager should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "share_accepter" {
  description = "Controls if Resource Access Manager resource share accepter should be created (it affects almost all resources)"
  type        = bool
  default     = false
}

variable "ram_resource_share_arn" {
  description = "The ARN of the resource share"
  type        = string
}
```
---

`terraform.tfvars`
```hcl
region      = "ap-northeast-2"
account_id  = ["098765432109"]
prefix      = "dev"

create_ram  = false
share_accepter = true
ram_resource_share_arn = "arn:aws:ram:ap-northeast-2:543210987612:resource-share/7003efe0-b7cd-4608-a701-7fa8590d9261"

tags = {
    "CreatedByTerraform" = "true"
    "TerraformModuleName" = "terraform-aws-module-resource-access-manager"
    "TeffaformModuleVersion" = "v1.0.0"
}
```
---

`outputs.tf`
```hcl
output "ram_resource_share_id" {
  value = module.ram.ram_resource_share_id
}

output "ram_resource_share_tags_all" {
  value = module.ram.ram_resource_share_tags_all
}
```
---

`data.tf`
```hcl
data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
```
