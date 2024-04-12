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
    key = "tfbblox2024/dev/platform-foundation.tfstate"
  }
}

provider "azurerm" {
  features {}
}

data "terraform_remote_state" "stage_shared" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.tfstate_resource_group_name
    storage_account_name = var.tfstate_storage_account_name
    container_name       = var.tfstate_container_name
    key                  = "tfbblox2024/dev/stage-shared.tfstate"
  }
}

module "k8s_foundation" {
  source                           = "../../../iac-tf-az-cloudtrain-building-block-modules//modules/container/kubernetes/foundation"
  region_name                      = var.region_name
  solution_name                    = var.solution_name
  solution_stage                   = var.solution_stage
  solution_fqn                     = var.solution_fqn
  common_tags                      = var.common_tags
  resource_group_id                = data.terraform_remote_state.stage_shared.outputs.resource_group_id
  network_cidr                     = var.network_cidr
  zones_to_span                    = var.zones_to_span
  kubernetes_api_access_cidrs      = var.kubernetes_api_access_cidrs
  kubernetes_workload_access_cidrs = var.kubernetes_workload_access_cidrs
  kubernetes_cluster_name          = var.kubernetes_cluster_name
  kubernetes_version               = var.kubernetes_version
  node_group_templates             = var.node_group_templates
  log_analytics_workspace_id       = data.terraform_remote_state.stage_shared.outputs.log_analytics_workspace_id
  key_vault_id                     = data.terraform_remote_state.stage_shared.outputs.key_vault_id
  admin_principal_ids              = var.admin_principal_ids
  public_dns_zone_id               = data.terraform_remote_state.stage_shared.outputs.public_dns_zone_id
}
