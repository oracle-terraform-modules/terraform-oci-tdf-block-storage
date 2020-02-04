# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "vols" {
  description = "The list of block volume ocids"
  value       = module.core_storage.vols
}


output "vol_grps" {
  description = "The list of block volume group and its ocid"
  value = {
    for i in module.core_storage.vol_grps :
    i.display_name => i.id
  }
}
