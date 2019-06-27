# ScaleFT Starter Kit: A single Ubuntu server on GCP

## Initial Configuration

This guide assumes you've completed some of the initial configurations described in the [ScaleFT Setup docs](https://www.scaleft.com/docs/), specifically from "Creating a Team" to "Configuring Projects". 

To use this repo, you will need a team and a project. In the project, you will need to grant permissions on the project to a user group (`everyone` will work fine), and to create an enrollment token.

You will also need to install & enroll a client. Here are the docs for this: https://www.scaleft.com/docs/setup/enrolling-a-client/

### SSH Configuration

It will also be helpful for you to configure your `ssh` client for use with ScaleFT.

This is a one-time setup step. You can do this with the command: `sft ssh-config >> ~/.ssh/config`

See also: https://www.scaleft.com/docs/setup/ssh/

#### From a Windows Desktop

Obviously, SSH is easier to use from a Mac or Linux desktop than from Windows. There are many different ways of installing and configuring ScaleFT with SSH on Windows, and if you'd like help with this, we're happy to help. Meanwhile, if you'd like to skip SSH configuration on your Windows desktop, I understand. In the examples below you can use our command `sft ssh <target>` instead.

See also: https://www.scaleft.com/docs/client/

## Google Cloud Platform Credentials

In the GCP console, create a service account from the IAM & Admin section. Download the generated credentials as `credentials.json` in the root of your project. Make sure to add this file to your .gitignore before pushing to a repo as it contains credentials to your GCP account!

## Install Terraform

*Note that the following example has been tested up to Terraform v0.11. v0.12 introduces some breaking changes which have yet to be updated.*

Download and install Terraform for your local OS here: https://www.terraform.io/downloads.html

To easily switch between Terraform versions during testing, use tfenv: https://github.com/tfutils/tfenv

## Terraform Input Variables

Create a `terraform.tfvars` file in this directory. 

In this file, include the following:
```
project = "■■■"
enrollment_token = "■■■"
```

### Fields

#### `project`

This is your GCP project id where the resources will be deployed.

#### `enrollment_token`

This is a ScaleFT Enrollment Token which you've created in the ScaleFT dashboard. Be sure to copy the entire enrollment token into this field!

## Creating the Environment

First, run the command `terraform init` to initialize the modules used.

Then, run the command `terraform apply` and be sure to check Terraform's output for errors!

You then wait a little bit, you can pass the time by checking the output of `sft list-servers` to see if your server is available. Once it appears there, move on to the next section. If it doesn't show up there, either Terraform encountered an error, or you may have incorrectly copy-pasted the enrollment token. Feel free to reach out to us to ask for help.

## Trying it out

First, run the command `sft login` to ensure you have an active session with ScaleFT. This may ask you to authenticate via your team's Identity Provider.

Then, run the command `ssh gcp-ubuntu-instance`. This will drop you into an SSH shell in the remote server. Take a look around. 

## Cleaning up

When you're done, you can remove this server with the command `terraform destroy`