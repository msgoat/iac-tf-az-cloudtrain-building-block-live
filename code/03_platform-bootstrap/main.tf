# ----------------------------------------------------------------------------
# main.tf
# ----------------------------------------------------------------------------

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
  backend "azurerm" {
    # Please provide all other information via the -backend-config command line argument
    key = "tfbblox2024/dev/platform-bootstrap.tfstate"
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

data "terraform_remote_state" "platform_foundation" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.tfstate_resource_group_name
    storage_account_name = var.tfstate_storage_account_name
    container_name       = var.tfstate_container_name
    key                  = "tfbblox2024/dev/platform-foundation.tfstate"
  }
}

# Kubernetes-related Terraform Providers -------------------------------------
locals {
  aks_cluster_id_parts            = split("/", data.terraform_remote_state.platform_foundation.outputs.k8s_cluster_id)
  aks_cluster_name                = local.aks_cluster_id_parts[8]
  aks_cluster_resource_group_name = local.aks_cluster_id_parts[4]
  aks_cluster_subscription        = local.aks_cluster_id_parts[2]
}

data "azurerm_kubernetes_cluster" "given" {
  name                = local.aks_cluster_name
  resource_group_name = local.aks_cluster_resource_group_name
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.given.kube_admin_config.0.host
  username               = data.azurerm_kubernetes_cluster.given.kube_admin_config.0.username
  password               = data.azurerm_kubernetes_cluster.given.kube_admin_config.0.password
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.given.kube_admin_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.given.kube_admin_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.given.kube_admin_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.given.kube_admin_config.0.host
    username               = data.azurerm_kubernetes_cluster.given.kube_admin_config.0.username
    password               = data.azurerm_kubernetes_cluster.given.kube_admin_config.0.password
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.given.kube_admin_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.given.kube_admin_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.given.kube_admin_config.0.cluster_ca_certificate)
  }
}

module "k8s_bootstrap" {
  source                          = "../../../iac-tf-az-cloudtrain-building-block-modules//modules/container/kubernetes/bootstrap"
  region_name                     = var.region_name
  solution_name                   = var.solution_name
  solution_stage                  = var.solution_stage
  solution_fqn                    = var.solution_fqn
  common_tags                     = var.common_tags
  k8s_cluster_id                  = data.terraform_remote_state.platform_foundation.outputs.k8s_cluster_id
  kubernetes_cluster_architecture = var.kubernetes_cluster_architecture
  letsencrypt_account_name        = var.letsencrypt_account_name
  admin_principal_ids             = var.admin_principal_ids
  public_dns_zone_id              = data.terraform_remote_state.stage_shared.outputs.public_dns_zone_id
  key_vault_id                    = data.terraform_remote_state.stage_shared.outputs.key_vault_id
  loadbalancer_id                 = data.terraform_remote_state.platform_foundation.outputs.loadbalancer_id
  resource_group_id               = data.terraform_remote_state.stage_shared.outputs.resource_group_id
}
