# LAB-04: Terraform State

In the previous LAB we used Terraform to create an Azure Resource Group. As part of the provisioning process Terraform created and wrote configuration data into a [terraform.tfstate](../terraform.state) file. Terraform uses state to track the individual resources it has created and assigns each resource a unique ID. This is how Terraform knows which resources it is managing.

>Important:
>
>As you can imagine, managing a securing the state file is extremely important. It is generally recommended that state is stored remotely and secured using ACLs and encryption. For more information regarding the storage of state refer to the following:
>
>* [Terraform Remote State](https://www.terraform.io/docs/state/remote.html)
>* [Terraform Enterprise Workspaces](https://www.terraform.io/docs/cloud/workspaces/index.html)

---

## Working with Terraform State
The terraform state command is used for advanced state management. As your Terraform usage becomes more advanced, there are some cases where you may need to modify the Terraform state. Rather than modify the state directly, the terraform state commands can be used in many cases instead. 

Run through the following examples to familiarize yourself with the state management workflow in Terraform.

>Tip:
>
>For a full list of available state based commands please refer to the following:
>* [State Command](https://www.terraform.io/docs/commands/state/index.html)

### Listing State
---
The `terraform state list` command is used to list resources within a Terraform state.
```
$ terraform state list
azurerm_resource_group.rg
```

### Show State
---
The `terraform state show` command is used to show the attributes of a single resource in the Terraform state.
```
$ terraform state show azurerm_resource_group.rg
# azurerm_resource_group.rg:
resource "azurerm_resource_group" "rg" {
    id       = "/subscriptions/<subscription_id>/resourceGroups/RG-Ryan_Hall-AE"
    location = "australiaeast"
    name     = "RG-Ryan_Hall-AE"
    tags     = {}
}
```

### Pull State
---
The `terraform state pull` command is used to manually download and output the state from remote state. This command also works with local state.
```
$ terraform state pull
{
  "version": 4,
  "terraform_version": "0.12.0",
  "serial": 1,
  "lineage": "499cce11-5645-1388-9909-2bf0dfc8a244",
  "outputs": {},
  "resources": [
    {
      "mode": "managed",
      "type": "azurerm_resource_group",
      "name": "rg",
      "provider": "provider.azurerm",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "id": "/subscriptions/<subscription_id>/resourceGroups/RG-Ryan_Hall-AE",
            "location": "australiaeast",
            "name": "RG-Ryan_Hall-AE",
            "tags": {}
          }
        }
      ]
    }
  ]
}
```
Proceed to the next [lesson](./05_Updating.md)

---