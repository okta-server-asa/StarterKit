# ScaleFT Starter Kit: A single Windows server on Azure

## Initial Configuration

This guide assumes you've completed some of the initial configurations described in the [ScaleFT Setup docs](https://www.scaleft.com/docs/), specifically from "Creating a Team" to "Configuring Projects". 

To use this repo, you will need a team and a project. In the project, you will need to grant permissions on the project to a user group (`everyone` will work fine), and to create an enrollment token.

You will also need to install & enroll a client. Here are the docs for this: https://www.scaleft.com/docs/setup/enrolling-a-client/

## Install Terraform

*Note that the following example has been tested up to Terraform v0.11. v0.12 introduces some breaking changes which have yet to be updated.*

Download and install Terraform for your local OS here: https://www.terraform.io/downloads.html

To easily switch between Terraform versions during testing, use tfenv: https://github.com/tfutils/tfenv

## Terraform Input Variables

Create a `terraform.tfvars` file in this directory. 

In this file, include the following:
```
subscription_id  = "■■■"
client_id        = "■■■"
client_secret    = "■■■"
tenant_id        = "■■■"
enrollment_token = "■■■"
admin_password   = "■■■"
```

### Fields

#### `subscription_id`, `client_id`, `client_secret`, `tenant_id`

These values are as described here: https://www.terraform.io/docs/providers/azurerm/authenticating_via_service_principal.html#creating-a-service-principal-in-the-azure-portal

#### `enrollment_token`

This is a ScaleFT Enrollment Token which you've created in the ScaleFT dashboard. Be sure to copy the entire enrollment token into this field!

#### `admin_password`

This is a required field for creating a Windows machine in Azure. If all goes well, you will not need this password. You also won't need the security group rule which permits port 3389 (RDP) to your target. These are just there for convenience.

## Creating the Environment

First, run the command `terraform init` to initialize the modules used.

Then, run the command `terraform apply` and be sure to check Terraform's output for errors!

You then wait a little bit, you can pass the time by checking the output of `sft list-servers` to see if your server is available. Once it appears there, move on to the next section. If it doesn't show up there, either Terraform encountered an error, or you may have incorrectly copy-pasted the enrollment token. Feel free to reach out to us to ask for help.

## Trying it out

Then, from within Powershell, run the command `sft rdp windows-target`. 

This will open an RDP session to the remote server. Take a look around. 

Here are some fun things to check out:

### Managed Local Users

Navigate to: Start -> Administrative Tools -> Computer Management -> Local Users And Groups -> Users

User accounts on the server are managed for each of the users to whom you've granted access in the ScaleFT platform.

Learn more: https://www.scaleft.com/docs/user-management/

### The ScaleFT Agent

Navigate to: Start -> Administrative Tools -> Services -> and scroll to ScaleFT Server Tools 

The ScaleFT Agent was installed on this server using Azure custom data and a custom script extension. The agent used the enrollment token you configured to join the project you created, and then created user accounts for the users you granted access to. When your RDP connection was received, the ScaleFT Agent validated the properties written into the ephemeral X.509 certificate before allowing your connection to proceed.

Learn more: https://www.scaleft.com/docs/windows/

### What happened?

Check out the Events tab in the ScaleFT Dashboard. You should see multiple audit events related to your RDP session, including the dynamic authorization decision that granted you access according to the RBAC and policies configured on your project, and the credential issuance step showing the X.509 certificate which was issued to you.

When you ran `sft rdp windows-target`, the ScaleFT client used the ScaleFT platform API to check if `centos-target` was the name of a server which you had been granted access to, and then to provide credentials for that server to your local RDP client, along with some helpful configurations, such as the server's IP address and host key. This is also the moment where SSH bastion hops would have been configured and applied, if a bastion was required for RDP access to this target.

Learn more: 

* https://www.scaleft.com/docs/server-name-resolution/

## Cleaning up

When you're done, you can remove this server with the command `terraform destroy`
