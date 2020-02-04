# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "core_storage" {
  source                     = "../.."
  default_compartment_id     = var.compartment_id
  default_ad                 = 0
  default_size_in_gbs        = 50
  default_backup_policy_name = "Bronze"
  default_defined_tags  = { "Tag.Owner" = "value" }
  default_freeform_tags = { "Environment" = "Testing" }

  vols = {
    av1 = {
      compartment_id     = null
      ad                 = null
      size_in_gbs        = 62
      backup_policy_name = null
      defined_tags       = null
      freeform_tags      = null
      source_id          = null
      source_type        = null
      vol_grp_name       = "ag1"
      kms_key_id         = null
    }
  }

  vol_grps = {
    ag1 = {
      compartment_id = null
      ad             = 0
      ext_vol_ids    = []
      defined_tags   = null
      freeform_tags  = null
    }
  }
}


# Attach volume:
# Adjust the below instances and count depending on your requirement :
# 1. Attach 2 block volumes to 1 instance
# 2. Attach in a 1 to 1 mapping (1st instance 1st volume, 2nd instance to 2nd volume and so on..)
# 3. Attach 1 block to 2 instances. (Read only)

# The below example covers point-3 scenario:


variable "instances" {
  default = ["", ""]
}

resource "oci_core_volume_attachment" "this" {
  depends_on      = [module.core_storage]
  count           = 2
  attachment_type = "iscsi"
  instance_id     = var.instances[count.index]
  volume_id       = module.core_storage.vols["av1"].id
  is_read_only    = true
  use_chap        = true

  provisioner "local-exec" {
    command = "sleep 10s" #waiting for some time
  }
}

data "oci_core_volume_attachments" "this" {
  # Required
  depends_on     = [module.core_storage]
  compartment_id = var.compartment_id
  # Optional
  volume_id = module.core_storage.vols["av1"].id
}
# Note: You may not see volume attachment details straight away, give it some time and re-run terraform apply to see the output.
output "oci_core_volume_attachments" {
  value = data.oci_core_volume_attachments.this
}
