# Oracle Cloud Infrastructure (OCI) Block Storage Module for Terraform

## Introduction
This module provides a way to provision an Oracle Cloud Infrastructure Block Storage Volume and Volume Groups.
 This serves as a foundational component in an OCI environment, providing the ability to provision Block Storage Volumes.


1. Create a block volumes 
2. Create a backup policies
3. Create a block volume groups and add volumes to it.
4. Create the volume from another source
5. Tagging (freeform or defined)


## Prerequisites

See the Oracle Cloud Infrastructure Provider docs for information about setting up and using the Oracle Cloud Infrastructure  Provider.
https://github.com/terraform-providers/terraform-provider-oci

This module does not create any dependencies or prerequisites. 

## Getting Started

Several fully-functional examples are provided in the `examples` directory.  

The following scenarios are covered in the examples:

* simple_block_volume: Provisioning a single volume and a volume group 
* attach_block_volume: Provision a volume and attach it to a pre-existing instance. 

## Accessing the Solution
This core service module is typically used at deployment, with no further access required.


## Module Inputs

### Provider 

The following IAM attributes are available in the the `terraform.tfvars` file:

```
### PRIMARY TENANCY DETAILS

# Get this from the bottom of the OCI screen (after logging in, after Tenancy ID: heading)
primary_tenancy_id="<tenancy OCID"
# Get this from OCI > Identity > Users (for your user account)
primary_user_id="<user OCID>"

# the fingerprint can be gathered from your user account (OCI > Identity > Users > click your username > API Keys fingerprint (select it, copy it and paste it below))
primary_fingerprint="<PEM key fingerprint>"
# this is the full path on your local system to the private key used for the API key pair
primary_private_key_path="<path to the private key that matches the fingerprint above>"

# region (us-phoenix-1, ca-toronto-1, etc)
primary_region="<your region>"

### DR TENANCY DETAILS

# Get this from the bottom of the OCI screen (after logging in, after Tenancy ID: heading)
dr_tenancy_id="<tenancy OCID"
# Get this from OCI > Identity > Users (for your user account)
dr_user_id="<user OCID>"

# the fingerprint can be gathered from your user account (OCI > Identity > Users > click your username > API Keys fingerprint (select it, copy it and paste it below))
dr_fingerprint="<PEM key fingerprint>"
# this is the full path on your local system to the private key used for the API key pair
dr_private_key_path="<path to the private key that matches the fingerprint above>"

# region (us-phoenix-1, ca-toronto-1, etc)
dr_region="<your region>"
```

### Block Volume 

| Attribute | Data Type | Required | Default Value | Valid Values | Description |
|---|---|---|---|---|---|
| compartment\_id | string | yes | none | compartment OCID | This is the compartment OCID |
| size\_in\_gbs | integer | yes | 60 | integer | Size of the block volume in GB |
| name | string | yes | my-oci-block-volume | string | The block volume name |
| ad | string | yes | AD1 | AD1, AD2 or AD3 | The block volume Availability domain name |
| backup_policy_name | string | no | none | Bronze, Silver or Gold | The block volume backup policy name |
| vol_group_name | string | no | none | string | The block volume group name to which this volume needs to be added. Example "vg1" or "vg2". Note the VG should be from same AD as the volume|
| defined_tags | map | no | {"KEY.Subkey" = "VALUE"} | map | Use this if you want a block volume defined tag (optional)|
| freeform_tags | map | no | {"KEY" = "VALUE"} | map | Use this if you want a block volume free form tag (optional)|
| source_id | list(string) | no | null | OCID of the source volume | The block volume source id to use (optional) |
| source_type | string | no | null | volume or volumebackup | The block volume source type (optional) |
| kms_key_id | string | no | null | kms key id | The kms key id (optional) |
| ext_vol_ids | list(string) | no | null | OCID of other existing volumes if required  | The existing block volumes to add (optional) |

**`Important Note`**
The Volume group AD and Volume AD should be same.


**Example**

The following example creates 3 Block Volumes and 2 Volume Groups.

```
module "example1" {

  source                     = "../.."
  default_compartment_id     = var.compartment_id
  default_ad                 = 0
  default_size_in_gbs        = 50
  default_backup_policy_name = "Bronze"
  default_defined_tags       = { "Team.Owner" = "example@acme.com" }
  default_freeform_tags      = { "Environment" = "Production" }

  vols = {

    bv1 = {
      compartment_id     = null
      ad                 = null
      size_in_gbs        = 62
      backup_policy_name = null
      defined_tags       = null
      freeform_tags      = null
      source_id          = null
      source_type        = null
      vol_grp_name       = "vg1"
      kms_key_id = null
    },
    bv2 = {
      compartment_id     = var.compartment_id
      ad                 = 0
      size_in_gbs        = 66
      backup_policy_name = "Gold"
      defined_tags       = null
      freeform_tags      = null
      source_id          = "ocid1.volume.oc1.phx.xxx"
      source_type        = "volume"
      vol_grp_name       = "vg1"
      kms_key_id = null
    },
    bv3 = {
      compartment_id     = var.compartment_id
      ad                 = 0
      size_in_gbs        = 65
      backup_policy_name = "Silver"
      defined_tags       = { "Team.Owner" = "owner@acme.com" }
      freeform_tags      = { "Environment" = "Testing" }
      source_id          = null
      source_type        = null
      vol_grp_name       = "vg2"
      kms_key_id = null
    }
  }

  vol_grps = {
    vg1 = {
      compartment_id = null
      ad             = 0
      ext_vol_ids       = ["ocid1.volume.oc1.phx.xxx"]
      defined_tags   = null
      freeform_tags  = null
    },
    vg2 = {
      compartment_id = null
      ad             = 0
      ext_vol_ids       = ["ocid1.volume.oc1.phx.xxx"]
      defined_tags   = null
      freeform_tags  = null
    }
  }
}
```

## URLs

For Oracle Cloud Infrastructure File Storage Service documentation, see https://docs.cloud.oracle.com/en-us/iaas/Content/Block/Concepts/overview.htm




## Versions
This module has been developed and tested by running terraform on macOS Mojave Version 10.14.5

```
user-mac$ terraform --version
Terraform v0.12.3
+ provider.oci v3.31.0
```

## Contributing

This project is open source. Oracle appreciates any contributions that are made by the open source community.


## License

Copyright (c) 2020 Oracle and/or its affiliates.

Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

See [LICENSE](LICENSE) for more details.