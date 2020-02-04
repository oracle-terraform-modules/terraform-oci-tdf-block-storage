# (OCI) Create Block Volume Module Example(Attach Block)

This example helps you create the following resources:
1. Create a block volume
2. Create a backup policy for that volume
3. Optional to create a volume group and add the volume to it
4. Create the volume from another source
5. Tagging (freeform or defined)
6. Attach the Volume to instances


## Prepare

Fill the terraform.tfvars.template with required information.

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
## Terraform Output

```
Outputs:

block_volume_groups = {}
block_volumes = [
  {
    "availability_domain" = "uFjs:PHX-AD-1"
    "compartment_id" = "ocid1.compartment.oc1..xxxx"
    "defined_tags" = {}
    "display_name" = "my-test-attach-vol-0"
    "freeform_tags" = {
      "Environment" = "Production"
    }
    "id" = "ocid1.volume.oc1.phx.xxxx"
    "is_hydrated" = true
    "size_in_gbs" = "60"
    "size_in_mbs" = "61440"
    "source_details" = []
    "state" = "AVAILABLE"
    "time_created" = "2019-07-22 00:46:33.099 +0000 UTC"
  },
]
oci_core_volume_attachments = {
  "compartment_id" = "ocid1.compartment.oc1..xxxx"
  "id" = "2019-07-08 05:34:13.265698 +0000 UTC"
  "volume_attachments" = [
    {
      "attachment_type" = "iscsi"
      "availability_domain" = "uFjs:PHX-AD-1"
      "chap_secret" = ""
      "chap_username" = ""
      "compartment_id" = "ocid1.compartment.oc1..xxxx"
      "device" = ""
      "display_name" = "volumeattachment20190708052742"
      "id" = "ocid1.volumeattachment.oc1.phx.xxxx"
      "instance_id" = "ocid1.instance.oc1.phx.xxxx"
      "ipv4" = "$ipv"
      "iqn" = "iqn.2015-12.com.oracleiaas:ab80219d-87f1-4926-899d-xxxx"
      "is_pv_encryption_in_transit_enabled" = false
      "is_read_only" = true
      "port" = $port
      "state" = "ATTACHED"
      "time_created" = "2019-07-08 05:27:42.332 +0000 UTC"
      "use_chap" = false
      "volume_id" = "ocid1.volume.oc1.phx.xxxx"
    },
    {
      "attachment_type" = "iscsi"
      "availability_domain" = "uFjs:PHX-AD-1"
      "chap_secret" = ""
      "chap_username" = ""
      "compartment_id" = "ocid1.compartment.oc1..xxxx"
      "device" = ""
      "display_name" = "volumeattachment20190708052742"
      "id" = "ocid1.volumeattachment.oc1.phx.xxxx"
      "instance_id" = "ocid1.instance.oc1.phx.xxxx"
      "ipv4" = "169.254.2.x"
      "iqn" = "iqn.2015-12.com.oracleiaas:ab80219d-87f1-4926-899d-xxxx"
      "is_pv_encryption_in_transit_enabled" = false
      "is_read_only" = true
      "port" = $port
      "state" = "ATTACHED"
      "time_created" = "2019-07-08 05:27:42.203 +0000 UTC"
      "use_chap" = false
      "volume_id" = "ocid1.volume.oc1.phx.xxxx"
    },
  ]
  "volume_id" = "ocid1.volume.oc1.phx.xxxx"
}
```

## Instructions for further attaching the volume on the linux instance for iscsi based volume attachments:

**`Set variables`**
```
iqn=<use from the terraform output>
ipv=<use from the terraform output>
port=<use from the terraform output>
```
**`Attach commands`**
```
sudo iscsiadm -m node -o new -T $iqn -p $ipv:$port
sudo iscsiadm -m node -o update -T $iqn -n node.startup -v automatic
sudo iscsiadm -m node -T $iqn -p $ipv:$port -l
```
**`Detach commands`**
```
sudo iscsiadm -m node -T $iqn -p $ipv:$port -u
sudo iscsiadm -m node -o delete -T $iqn -p $ipv:$port


chap_user_name=
chap_secret=

sudo iscsiadm -m node -o new -T $iqn -p $iqv:$port
sudo iscsiadm -m node -o update -T $iqn -n node.startup -v automatic
sudo iscsiadm -m node -T $iqn -p $iqv:$port -o update -n node.session.auth.authmethod -v CHAP
sudo iscsiadm -m node -T $iqn -p $iqv:$port -o update -n node.session.auth.username -v $chap_user_name
sudo iscsiadm -m node -T $iqn -p $iqv:$port -o update -n node.session.auth.password -v $chap_secret
sudo iscsiadm -m node -T $iqn -p $iqv:$port -l

Detach:
sudo iscsiadm -m node -T $iqn -p $ipv:$port -u
sudo iscsiadm -m node -o delete -T $iqn -p $ipv:$port

```

Read https://docs.cloud.oracle.com/iaas/Content/Block/Tasks/attachingavolume.htm for more information.
```
Contributor/Developer: Venugopal Naik
```
