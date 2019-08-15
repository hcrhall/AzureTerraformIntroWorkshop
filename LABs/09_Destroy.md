# LAB-09: Destroying Infrastructure
You have now seen how to build and change infrastructure. Before you move on to creating multiple resources and showing resource dependencies, you should know how to completely destroy the Terraform-managed infrastructure.

Destroying your infrastructure is a rare event in production environments. But if you're using Terraform to spin up multiple environments such as development, test, QA environments, then destroying is a useful action.

---

## Terraform Destroy
Resources can be destroyed using the `terraform destroy` command, which is similar to `terraform apply` but it behaves as if all of the resources have been removed from the configuration. 

Run `terraform destroy -var "owner=foo" -auto-approve` and review the output that is returned by the Terraform CLI:

```
$ terraform destroy -var "owner=foo" -auto-approve
module.compute.azurerm_virtual_machine.vm-linux[0]: Destruction complete after 1m30s
random_password.password: Destruction complete after 0s
module.compute.azurerm_availability_set.vm: Destruction complete after 1s
module.compute.azurerm_network_interface.vm[0]: Destruction complete after 11s
module.compute.azurerm_public_ip.vm[0]: Destruction complete after 0s
module.network.azurerm_subnet.subnet[0]: Destruction complete after 10s
module.compute.azurerm_network_security_group.vm: Destruction complete after 10s
module.network.azurerm_virtual_network.vnet: Destruction complete after 11s
module.network.azurerm_resource_group.network: Destruction complete after 47s
azurerm_resource_group.rg: Destroying... [id=/subscriptions/<subscription_id>/resourceGroups/RG-Ryan_Hall-AE]
module.compute.azurerm_resource_group.vm: Destruction complete after 2m48s

Destroy complete! Resources: 13 destroyed.
```
>**Information:**
>
>Just like with `apply`, Terraform determines the order in which things must be destroyed. In more complicated cases with multiple resources, Terraform will destroy them in a suitable order to respect resource dependencies.

---