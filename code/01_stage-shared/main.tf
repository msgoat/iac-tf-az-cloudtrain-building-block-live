# ----------------------------------------------------------------------------
# main.tf
# ----------------------------------------------------------------------------

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    # Please provide all other information via the -backend-config command line argument
    key = "tfbblox2024/dev/stage-shared.tfstate"
  }
}

provider "azurerm" {
  features {}
}

module shared {
  source                = "../../../iac-tf-az-cloudtrain-building-block-modules//modules/stage/shared"
  region_name           = var.region_name
  solution_name         = var.solution_name
  solution_stage        = var.solution_stage
  solution_fqn          = var.solution_fqn
  common_tags           = var.common_tags
  resource_group_name   = var.resource_group_name
  public_dns_zone_name         = var.public_dns_zone_name
  parent_dns_zone_id    = var.parent_dns_zone_id
  admin_principal_ids       = var.admin_principal_ids
}
