# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  vols_default = {
    compartment_id     = ""
    name               = "my-oci-block-volume"
    ad                 = 0
    size_in_gbs        = 60
    backup_policy_name = "Bronze"
    defined_tags       = {}
    freeform_tags      = {}
    source_id          = null
    source_type        = "volume"
    kms_key_id         = null
  }


  vols = var.vols != null ? var.vols : {}


  vols_w_o_kms = { for k, v in local.vols :
    k => v
    if v.kms_key_id == null
  }

  vols_w_kms = { for k, v in local.vols :
    k => v
    if v.kms_key_id != null
  }

  keys_vols_w_o_kms = keys(local.vols_w_o_kms)
  keys_vols_w_kms   = keys(local.vols_w_kms)
  total_vol_key_len = (length(local.keys_vols_w_o_kms) + length(local.keys_vols_w_kms))
}

resource "oci_core_volume" "this_w_o_kms" {
  count               = length(local.keys_vols_w_o_kms)
  availability_domain = local.vols_w_o_kms[local.keys_vols_w_o_kms[count.index]].ad == null ? (var.default_ad == null ? lookup(data.oci_identity_availability_domains.ads.availability_domains[local.vols_default.ad], "name") : lookup(data.oci_identity_availability_domains.ads.availability_domains[var.default_ad], "name")) : lookup(data.oci_identity_availability_domains.ads.availability_domains[local.vols_w_o_kms[local.keys_vols_w_o_kms[count.index]].ad], "name")

  compartment_id = local.vols_w_o_kms[local.keys_vols_w_o_kms[count.index]].compartment_id != null ? local.vols_w_o_kms[local.keys_vols_w_o_kms[count.index]].compartment_id : var.default_compartment_id

  #Optional
  backup_policy_id = local.vols_w_o_kms[local.keys_vols_w_o_kms[count.index]].backup_policy_name != null ? "${lookup(data.oci_core_volume_backup_policies.volume_backup_policies.volume_backup_policies[var.backup_policy[local.vols_w_o_kms[local.keys_vols_w_o_kms[count.index]].backup_policy_name]], "id")}" : (var.default_backup_policy_name != null ? "${lookup(data.oci_core_volume_backup_policies.volume_backup_policies.volume_backup_policies[var.backup_policy[var.default_backup_policy_name]], "id")}" : "")
  defined_tags     = local.vols_w_o_kms[local.keys_vols_w_o_kms[count.index]].defined_tags != null ? local.vols_w_o_kms[local.keys_vols_w_o_kms[count.index]].defined_tags : (var.default_defined_tags != null ? var.default_defined_tags : local.vols_default.defined_tags)
  display_name     = local.keys_vols_w_o_kms[count.index] != null ? local.keys_vols_w_o_kms[count.index] : "${local.vols_default.display_name}-${count.index}"
  freeform_tags    = local.vols_w_o_kms[local.keys_vols_w_o_kms[count.index]].freeform_tags != null ? local.vols_w_o_kms[local.keys_vols_w_o_kms[count.index]].freeform_tags : (var.default_freeform_tags != null ? var.default_freeform_tags : local.vols_default.freeform_tags)
  size_in_gbs      = local.vols_w_o_kms[local.keys_vols_w_o_kms[count.index]].size_in_gbs != null ? local.vols_w_o_kms[local.keys_vols_w_o_kms[count.index]].size_in_gbs : (var.default_size_in_gbs != null ? var.default_size_in_gbs : local.vols_default.size_in_gbs)
  dynamic "source_details" {
    for_each = local.vols_w_o_kms[local.keys_vols_w_o_kms[count.index]].source_id == null ? [] : ["1"]
    content {
      id   = local.vols_w_o_kms[local.keys_vols_w_o_kms[count.index]].source_id != null ? local.vols_w_o_kms[local.keys_vols_w_o_kms[count.index]].source_id : ""
      type = local.vols_w_o_kms[local.keys_vols_w_o_kms[count.index]].source_type != null ? local.vols_w_o_kms[local.keys_vols_w_o_kms[count.index]].source_type : local.vols_default.source_type
    }
  }
}

resource "oci_core_volume" "this_w_kms" {
  count               = length(local.keys_vols_w_kms)
  availability_domain = local.vols_w_kms[local.keys_vols_w_kms[count.index]].ad == null ? (var.default_ad == null ? lookup(data.oci_identity_availability_domains.ads.availability_domains[local.vols_default.ad], "name") : lookup(data.oci_identity_availability_domains.ads.availability_domains[var.default_ad], "name")) : lookup(data.oci_identity_availability_domains.ads.availability_domains[local.vols_w_kms[local.keys_vols_w_kms[count.index]].ad], "name")

  compartment_id = local.vols_w_kms[local.keys_vols_w_kms[count.index]].compartment_id != null ? local.vols_w_kms[local.keys_vols_w_kms[count.index]].compartment_id : var.default_compartment_id

  # Optional
  backup_policy_id = local.vols_w_kms[local.keys_vols_w_kms[count.index]].backup_policy_name != null ? "${lookup(data.oci_core_volume_backup_policies.volume_backup_policies.volume_backup_policies[var.backup_policy[local.vols_w_kms[local.keys_vols_w_kms[count.index]].backup_policy_name]], "id")}" : (var.default_backup_policy_name != null ? "${lookup(data.oci_core_volume_backup_policies.volume_backup_policies.volume_backup_policies[var.backup_policy[var.default_backup_policy_name]], "id")}" : "")
  defined_tags     = local.vols_w_kms[local.keys_vols_w_kms[count.index]].defined_tags != null ? local.vols_w_o_kms[local.keys_vols_w_kms[count.index]].defined_tags : (var.default_defined_tags != null ? var.default_defined_tags : local.vols_default.defined_tags)
  display_name     = local.keys_vols_w_kms[count.index] != null ? local.keys_vols_w_kms[count.index] : "${local.vols_default.display_name}-${count.index}"
  freeform_tags    = local.vols_w_kms[local.keys_vols_w_kms[count.index]].freeform_tags != null ? local.vols_w_kms[local.keys_vols_w_kms[count.index]].freeform_tags : (var.default_freeform_tags != null ? var.default_freeform_tags : local.vols_default.freeform_tags)
  kms_key_id       = local.vols_w_kms[local.keys_vols_w_kms[count.index]].kms_key_id
  size_in_gbs      = local.vols_w_kms[local.keys_vols_w_kms[count.index]].size_in_gbs != null ? local.vols_w_kms[local.keys_vols_w_kms[count.index]].size_in_gbs : (var.default_size_in_gbs != null ? var.default_size_in_gbs : local.vols_default.size_in_gbs)

  
  dynamic "source_details" {
    for_each = local.vols_w_kms[local.keys_vols_w_kms[count.index]].source_id == null ? [] : ["1"]
    content {
      id   = local.vols_w_kms[local.keys_vols_w_kms[count.index]].source_id != null ? local.vols_w_kms[local.keys_vols_w_kms[count.index]].source_id : ""
      type = local.vols_w_kms[local.keys_vols_w_kms[count.index]].source_type != null ? local.vols_w_kms[local.keys_vols_w_kms[count.index]].source_type : local.vols_default.source_type
    }
  }
}

/*
Logic explained:
Use case:- Have volume group names input variable inside the volume interface. 

1. First create a map of volume names to their ocids. refer all_vol_id_map below
2. Then create a map named vol_ids of {volume group names : ocids}. the ocids are looked up from all_vol_id_map created in step 1.
3. Finally in oci_core_volume_group resource we concat ext_vol_ids (which are user inputted external volumes) and vol_ids 
*/
locals {
  vol_grps_default = {
    volume_group_name = "my-oci-volume-group"
    ad                = 0
    compartment_id    = ""
    defined_tags      = {}
    freeform_tags     = {}
    all_vol_id_map = local.total_vol_key_len == null ? {} : merge(
      {
        for k in oci_core_volume.this_w_kms :
        k.display_name => k.id
      },
      {
        for k in oci_core_volume.this_w_o_kms :
        k.display_name => k.id
      }
    )
  }

}
locals {
  vol_ids = local.total_vol_key_len == null ? {} : {
    for k, v in local.vols :
    v.vol_grp_name => local.vol_grps_default.all_vol_id_map[k]...
    if v.vol_grp_name != null
  }

}

resource "oci_core_volume_group" "this" {
  # Required
  depends_on          = [oci_core_volume.this_w_kms, oci_core_volume.this_w_o_kms]
  count               = var.vol_grps != null ? length(keys(var.vol_grps)) : 0
  availability_domain = var.vol_grps[keys(var.vol_grps)[count.index]].ad == null ? (var.default_ad == null ? lookup(data.oci_identity_availability_domains.ads.availability_domains[local.vols_default.ad], "name") : lookup(data.oci_identity_availability_domains.ads.availability_domains[var.default_ad], "name")) : lookup(data.oci_identity_availability_domains.ads.availability_domains[var.vol_grps[keys(var.vol_grps)[count.index]].ad], "name")
  compartment_id      = var.vol_grps[keys(var.vol_grps)[count.index]].compartment_id != null ? var.vol_grps[keys(var.vol_grps)[count.index]].compartment_id : var.default_compartment_id

  source_details {
    # Required
    type       = "volumeIds"
    volume_ids = local.total_vol_key_len == 0 ? (var.vol_grps[keys(var.vol_grps)[count.index]].ext_vol_ids != null ? concat(var.vol_grps[keys(var.vol_grps)[count.index]].ext_vol_ids) : []) : (var.vol_grps[keys(var.vol_grps)[count.index]].ext_vol_ids != null ? (concat(var.vol_grps[keys(var.vol_grps)[count.index]].ext_vol_ids, contains(keys(local.vol_ids), keys(var.vol_grps)[count.index]) ? local.vol_ids[keys(var.vol_grps)[count.index]] : [])) : (contains(keys(local.vol_ids), keys(var.vol_grps)[count.index]) ? local.vol_ids[keys(var.vol_grps)[count.index]] : []))

  }
  # Optional
  display_name  = keys(var.vol_grps)[count.index] != null ? keys(var.vol_grps)[count.index] : "${local.vol_grps_default.display_name}-${count.index}"
  defined_tags  = var.vol_grps[keys(var.vol_grps)[count.index]].defined_tags != null ? var.vol_grps[keys(var.vol_grps)[count.index]].defined_tags : (var.default_defined_tags != null ? var.default_defined_tags : local.vol_grps_default.defined_tags)
  freeform_tags = var.vol_grps[keys(var.vol_grps)[count.index]].freeform_tags != null ? var.vol_grps[keys(var.vol_grps)[count.index]].freeform_tags : (var.default_freeform_tags != null ? var.default_freeform_tags : local.vol_grps_default.freeform_tags)
}

resource "oci_core_volume_backup_policy_assignment" "this_w_kms" {

  count     = length(local.keys_vols_w_kms)
  asset_id  = oci_core_volume.this_w_kms[count.index].id
  policy_id = "${lookup(data.oci_core_volume_backup_policies.volume_backup_policies.volume_backup_policies[var.backup_policy[local.vols_w_kms[local.keys_vols_w_kms[count.index]].backup_policy_name != null ? local.vols_w_kms[local.keys_vols_w_kms[count.index]].backup_policy_name : local.vols_default.backup_policy_name]], "id")}"
}

resource "oci_core_volume_backup_policy_assignment" "this_w_o_kms" {

  count     = length(local.keys_vols_w_o_kms)
  asset_id  = oci_core_volume.this_w_o_kms[count.index].id
  policy_id = "${lookup(data.oci_core_volume_backup_policies.volume_backup_policies.volume_backup_policies[var.backup_policy[local.vols_w_o_kms[local.keys_vols_w_o_kms[count.index]].backup_policy_name != null ? local.vols_w_o_kms[local.keys_vols_w_o_kms[count.index]].backup_policy_name : local.vols_default.backup_policy_name]], "id")}"
}
