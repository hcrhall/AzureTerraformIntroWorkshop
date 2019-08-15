# LAB-03: Provisioning Infrastructure
In this lesson you will use the configuration created in the previous lesson to build infrastructure on Azure.

---

## Configuration Initialization
The first command to run for any new Terraform configuration is `terraform init`. This will initialize various local settings and data that will be used by any subsequent commands.

Within the VSCode terminal, execute the `terraform init` command and review the output that is returned by the Terraform CLI which should look as follows:
```
Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "azurerm" (terraform-providers/azurerm) 1.32.1...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

>**Tip:** 
>
>Once the init process has completed, review the directory structure in the working directory. You will notice that a [.terraform](./.terraform) directory has been created in the directory that contains the [main.tf](./main.tf). This directory has a sub-directory called [plugins](./terraform/plugins) that contains all Terraform [Providers](https://www.terraform.io/docs/providers/index.html) that were downloaded as part of the initialization process.

## Applying Changes
Now that we have initialized the working directory and downloaded all prerequisite plugins, the next step of the workflow is to apply the configuration changes to our Azure subscription. We do this by running the `terraform apply` command.

Within the VSCode terminal, run `terraform apply` and review the output that is returned by the Terraform CLI which should resemble the following:

```
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_resource_group.rg will be created
  + resource "azurerm_resource_group" "rg" {
      + id       = (known after apply)
      + location = "australiaeast"
      + name     = "RG-Ryan_Hall-AE"
      + tags     = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:
```
>**Note:**
>
>The CLI output shows the execution plan, describing which actions Terraform will take in order to change real infrastructure to match the configuration. When the output has a `+` next to **azurerm_resource_group.rg**, this indicates that Terraform will create the resource. Beneath that, it shows the properties that will be set. When the value displayed is `<computed>`, it means that the value is unknown.

Once you have verified that the Azure Resource Group resource will be created, type `yes` and press `Return`.

Terraform will start creating the relevant resource and will log to stdout. You can debug Terraform by changiong the log level. This can be set using the [TF_LOG](https://www.terraform.io/docs/internals/debugging.html) environment variable.

Proceed to the next [lesson](./04_State.md)

---
  














