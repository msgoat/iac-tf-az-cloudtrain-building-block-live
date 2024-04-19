variable "region_name" {
  description = "The name of the region to deploy into."
  type        = string
}

variable "solution_name" {
  description = "The name of the cloud solution that owns all cloud resources."
  type        = string
}

variable "solution_stage" {
  description = "The name of the current solution stage."
  type        = string
}

variable "solution_fqn" {
  description = "The fully qualified name of the cloud solution."
  type        = string
}

variable "common_tags" {
  description = "Common tags to be attached to all cloud resources"
  type        = map(string)
}

variable "tfstate_resource_group_name" {
  description = "Name of the resource group owning the remote Terraform state."
  type        = string
}

variable "tfstate_storage_account_name" {
  description = "Name of the storage account containing the remote Terraform state."
  type        = string
}

variable "tfstate_container_name" {
  description = "Name of the storage container holding the remote Terraform state."
  type        = string
}
