# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# Global variables
variable "default_compartment_id" {
  type = string
}
variable "default_ad" {
  type    = number
  default = null
}
variable "default_size_in_gbs" {
  type    = number
  default = null
}
variable "default_backup_policy_name" {
  type    = string
  default = ""
}
variable "default_defined_tags" {
  type    = map(string)
  default = {}
}
variable "default_freeform_tags" {
  type    = map(string)
  default = {}
}

variable "vols" {
  type = map(object({
    compartment_id     = string,
    ad                 = number,
    size_in_gbs        = number,
    backup_policy_name = string,
    defined_tags       = map(string),
    freeform_tags      = map(string),
    source_id          = string,
    source_type        = string,
    kms_key_id         = string
    vol_grp_name       = string
  }))
  description = "Parameters for block volume"
  default = {
    compartment_id     = null
    ad                 = null
    size_in_gbs        = null
    backup_policy_name = null
    defined_tags       = null
    freeform_tags      = null
    source_id          = null
    source_type        = null
    kms_key_id         = null
    vol_grp_name       = null
  }
}

variable "vol_grps" {
  type = map(object({
    compartment_id = string,
    ad             = number,
    ext_vol_ids    = list(string)
    defined_tags   = map(string),
    freeform_tags  = map(string)
  }))
  description = "Parameters for block volume group"
  default = {
    compartment_id = null
    ad             = null
    ext_vol_ids    = null
    defined_tags   = null
    freeform_tags  = null
  }
}

variable "backup_policy" {
  type = "map"
  default = {
    "Bronze" = 1
    "Gold"   = 2
    "Silver" = 0
  }
}
