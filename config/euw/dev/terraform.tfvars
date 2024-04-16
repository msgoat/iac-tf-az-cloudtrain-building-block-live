region_name="westeurope"
solution_name="iactrain"
solution_stage="dev"
solution_fqn="iactrain-dev"
common_tags={
  Organization = "msg systems ag"
  BusinessUnit = "Branche Automotive"
  Department = "PG Cloud"
  ManagedBy = "Terraform"
}
backend_name = "tfbblox2024"
public_dns_zone_name = "tfbblox2024-dev.cloudtrain.azure.msgoat.eu"
parent_dns_zone_id = "/subscriptions/227d5934-f446-4e1b-b8d2-06f2942b64cb/resourcegroups/rg-eu-west-cloudtrain-core/providers/Microsoft.Network/dnsZones/cloudtrain.azure.msgoat.eu"
host_names = ["tfbblox2024-dev.cloudtrain.azure.msgoat.eu"]
zones_to_span = [ "1", "2"]
network_cidr="10.17.0.0/16"
kubernetes_version="1.28"
kubernetes_cluster_name="k8stst2024"
kubernetes_cluster_architecture="ARM_64"
kubernetes_api_access_cidrs=[ "0.0.0.0/0" ]
kubernetes_workload_access_cidrs=[ "0.0.0.0/0" ]
node_group_templates = [
  {
    name          = "sysblue" # logical name of this nodegroup
    role          = "MASTER"
    min_size      = 3                   # minimum size of this node group
    max_size      = 6                   # maximum size of this node group
    desired_size  = 3                   # desired size of this node group; will default to min_size if set to 0
    disk_size     = 64                  # size of attached root volume in GB
    instance_types = ["Standard_D2pds_v5"/*"Standard_D4pls_v5"*/] # virtual machine instance type which should be used for the worker node groups
    cpu_architecture   = "ARM_64"
  },
  {
    name          = "appsblue" # logical name of this nodegroup
    role          = "WORKER"
    min_size      = 4                   # minimum size of this node group
    max_size      = 12                  # maximum size of this node group
    desired_size  = 4                   # desired size of this node group; will default to min_size if set to 0
    disk_size     = 64                  # size of attached root volume in GB
    instance_types = ["Standard_D4pds_v5"/*"Standard_D8pls_v5"*/] # virtual machine instance type which should be used for the worker node groups
    cpu_architecture   = "ARM_64"
  }
]
admin_principal_ids = ["485ed2bc-f530-4bc7-8d1c-9ee57999a4f1"]
resource_group_name = "tfbblox2024"
# Common remote container of Terraform state
tfstate_resource_group_name  = "rg-euw-iactrain-dev-tfbblox2024-tfstate"
tfstate_storage_account_name = "stuxnz706x4ebzixnd3dafij"
tfstate_container_name       = "tfstate"
letsencrypt_account_name = "msg.O.GBA.CloudTrain@msg.group"
# Controls if OpenTelemetry support should be enabled
opentelemetry_enabled = true
# Host name of the OpenTelemetry collector endpoint; required if `opentelemetry_enabled` is true
opentelemetry_collector_host = "tracing-jaeger-collector.tracing"
# Port number of the OpenTelemetry collector endpoint; required if `opentelemetry_enabled` is true
opentelemetry_collector_port = 4317

