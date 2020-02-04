# (OCI)) Block Storage Module for Terraform Example (Simple)

This module helps you to:
1. Create a block volume 
2. Create a backup policy for that volume
3. Optional to create a volume group and add the volume to it.
4. Create the volume from another source
5. Tagging (freeform or defined)

## Prepare 

Rename `terraform.tfvars.template` file to `terraform.tfvars` and fill it with required information:

```
$ cat terraform.tfvars
# Oracle Cloud Infrastructure Authentication details
tenancy_id = "ocid1.tenancy.oc1..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
user_id = "ocid1.user.oc1..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
fingerprint= "xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx"
private_key_path = "~/.oci/oci_api_key.pem"

# Region
region = "us-phoenix-1"

# Compartment
compartment_id = "ocid1.compartment.oc1..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

## Apply

```
$ terraform init
$ terraform plan
$ terraform apply
```

```
Contributor/Developer: Venugopal Naik
```