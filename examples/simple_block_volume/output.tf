# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "vols" {
  description = "The block volume map"
  value       = module.example1.vols
}

output "vol_grps" {
  description = "The block volume group map"
  value       = module.example1.vol_grps
}

output "bkp_policies" {
  description = "Details of backup policies"
  value       = module.example1.bkp_policies
} 
