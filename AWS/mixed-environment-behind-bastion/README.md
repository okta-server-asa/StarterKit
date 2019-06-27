# ScaleFT Starter Kit: An Ubuntu server behind an Ubuntu bastion

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

## Install Terraform

*Note that the following example has been tested up to Terraform v0.11. v0.12 introduces some breaking changes which have yet to be updated.*

Download and install Terraform for your local OS here: https://www.terraform.io/downloads.html

To easily switch between Terraform versions during testing, use tfenv: https://github.com/tfutils/tfenv

## Terraform Input Variables

Create a `terraform.tfvars` file in this directory. 

In this file, include the following:
```
access_key = "■■■"
secret_key = "■■■"
enrollment_token = "■■■"
```

### Fields

#### `access_key`, `secret_key`

This is an appropriate AWS key id and secret from your AWS account which Terraform will use to create these these servers.

#### `enrollment_token`

This is a ScaleFT Enrollment Token which you've created in the ScaleFT dashboard. Be sure to copy the entire enrollment token into this field!

## Creating the Environment

First, run the command `terraform init` to initialize the modules used.

Then, run the command `terraform apply` and be sure to check Terraform's output for errors!

You then wait a little bit, you can pass the time by checking the output of `sft list-servers` to see if your servers are available. Once they both appear there, move on to the next section. If they don't show up there, either Terraform encountered an error, or you may have incorrectly copy-pasted the enrollment token. Feel free to reach out to us to ask for help.

## Trying it out

First, run the command `sft login` to ensure you have an active session with ScaleFT. This may ask you to authenticate via your team's Identity Provider.

Then, run the command `ssh ubuntu-target`. This will drop you into an SSH shell in the remote server behind the bastion. Take a look around. 

Here are some fun things to check out:

```
last | head
```

Look at the IP address you've connected from. It's a private IP address, the address of the `ubuntu-bastion` server we created.

```
ls -a ~ 
```

Notice that there is no `.ssh` directory. This is because you used an ephemeral client certificate to authenticate to the server. This certificate had a TTL of somewhere between 3 and 10 minutes (to account for possible clock drift), and can only authorize a login to that server within that interval of time.

```
ls /home
```

User accounts have been created for each user to whom you've granted access in ScaleFT. These user accounts will be kept up to date.

```
whoami
```

Notice that your username is based on your name as supplied by your Identity Provider, and is not, for example, the default value, which is the username on your desktop.

```
sudo grep -B 1 TrustedUserCAKeys /etc/ssh/sshd_config
```

This is the configuration which the ScaleFT agent adds to `sshd`. This specifies the path where `sshd` will find the public key of the Certificate Authority to trust. This CA belongs to the project you created in ScaleFT.

```
sudo cat /var/lib/sftd/ssh_ca.pub
```

This is the CA public key itself. The ScaleFT agent creates this file when the server is enrolled in the project.

### Connecting directly to the bastion

Just run the command `ssh ubuntu-bastion` and try the commands above out. Note that, this time, you are connecting directly in.

### Other tools

You can also use ScaleFT with anything else that uses SSH, for example, `rsync`, `git`, `scp`, even Ansible or other configuration management systems.

Of course, you can also run remote commands with SSH, such as `ssh ubuntu-target "hostname ; uptime ; uname -a ;"`

Everything connecting to this server with ScaleFT will be transparently routed over the bastion.

### What happened?

Check out the Events tab in the ScaleFT Dashboard. You should see multiple audit events related to your `ssh` command, including the dynamic authorization decision that granted you access, the credential issuance step showing the moment that a certificate was issued to you, and the SSH login events showing when you logged into the bastion and remote server with SSH authentication algorithm `RSA_CERT`.

When you ran `ssh ubuntu-target`, in the background, the `ProxyCommand` integration allowed the ScaleFT platform to check if `ubuntu-target` was the name of a server which you had been granted access to, and then to provide a certificate for that server to your local `ssh` client, along with some helpful configurations, such as the server's IP address and host key.

This is also when your `ssh` client was configured to use the `ubuntu-bastion` server as an SSH bastion. This happened transparently in the background and will also work for any tool which uses SSH as a transport.

Learn more: 

* https://www.scaleft.com/docs/server-name-resolution/
* https://www.scaleft.com/docs/sshkeys/

## Cleaning up

When you're done, you can remove this server with the command `terraform destroy`
