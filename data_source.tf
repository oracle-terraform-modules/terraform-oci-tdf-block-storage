# Availability Domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.default_compartment_id
}

data "oci_core_volume_backup_policies" "volume_backup_policies" {
}
