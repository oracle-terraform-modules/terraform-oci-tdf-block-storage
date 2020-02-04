# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "vols" {
  description = "The block volume details"
  value = merge(
    { for x in oci_core_volume.this_w_o_kms :
      x.display_name => x
    },
    { for x in oci_core_volume.this_w_kms :
      x.display_name => x
    }
  )
}

output "vol_grps" {
  description = "The block volume group details"
  value = {
    for x in oci_core_volume_group.this :
    x.display_name => x
  }
}

output "bkp_policies" {
  description = "Details of backup policies"
  value = {
    for k, v in data.oci_core_volume_backup_policies.volume_backup_policies.volume_backup_policies :
    v.display_name => v.id
  }
}
