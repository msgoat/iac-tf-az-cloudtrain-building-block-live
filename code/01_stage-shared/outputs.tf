output "resource_group_id" {
  description = "Unique identifier of the resource group containing all resources of this stage"
  value       = module.shared.resource_group_id
}

output "key_vault_id" {
  description = "Unique identifier of the Azure Key Vault instance managing all confidential stuff for this stage"
  value       = module.shared.key_vault_id
}

output "log_analytics_workspace_id" {
  description = "Unique identifier of the Azure Log Analytics Workspace managing all telemetry data for this stage"
  value       = module.shared.log_analytics_workspace_id
}

output "public_dns_zone_id" {
  description = "Unique identifier of the Azure Public DNS Zone managing all DNS records pointing to this stage"
  value       = module.shared.public_dns_zone_id
}
