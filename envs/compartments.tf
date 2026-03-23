/************************************************************
Compartment - workload
************************************************************/
resource "oci_identity_compartment" "workload" {
  compartment_id = var.tenancy_ocid
  name           = "oci-compute-custom-metrics-broadcast-management-agent-plugin"
  description    = "For OCI Compute Custom Metrics Broadcast Management Agent Plugin"
  enable_delete  = true
}