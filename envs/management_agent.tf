/************************************************************
Install Key
************************************************************/
resource "oci_management_agent_management_agent_install_key" "windows" {
  compartment_id            = oci_identity_compartment.workload.id
  display_name              = "windows-key"
  allowed_key_install_count = 1
  is_unlimited              = false
}