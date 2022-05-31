# simple_terraform_on_ibm_cloud
A simple example of how to use Terraform to build a straightforward environment in IBM Cloud

## Introduction

The repo is a good introduction to using Terraform to build resources on the IBM Cloud
It will create a virtual private cloud (VPC) and then set up a virtual server on it.
The server is a simple web server you can access via curl or ssh.

This repo is based on the code found in this repo:
Setup Terraform Environment for IBM Cloud
https://ibm.github.io/cloud-enterprise-examples/iac/setup-environment/

Specifically, the files found here in the 01-getting-started section
https://github.com/IBM/cloud-enterprise-examples/tree/master/iac/01-getting-started

Before you get started, go to this link to setup your terraform environment for IBM Cloud
https://ibm.github.io/cloud-enterprise-examples/iac/setup-environment/

For more instruction, go here: 
https://ibm.github.io/cloud-enterprise-examples/iac/content-overview

## Files
- main.tf: the main terraform module. It will set up your ssh keys, and your VSI instance (i.e. your server)
- network.tf: builds the VPC where your VSI resides, including setting up subnets, security groups, and more
- output.tf: will output the IP address and the entry point of your server
- provider.tf: information on IBM Cloud
- variables.tf: variables used by the modules. You will need an ssh key for the variable "public_key_file"
- example.tfvars: rename that to terraform.tfvars and fill in the values
NB: If you do not have the SSH key pair files, generate them with the command `ssh-keygen` (just for Mac OS X or Linux).


## Quick Start

In a nutshell, to play the example just execute the following commands:

```
terraform init
terraform plan
terraform apply

terraform output ip_address
curl "http://$<IP address output>:<port_output>"

ssh -i ~/.ssh/id_rsa ubuntu@<IP address output> "echo 'Hello World'"

ssh -i ~/.ssh/id_rsa ubuntu@<IP address output>
# Exit from the instance with: exit

terraform destroy
```

For this repo, I used:
terraform v1.1.9
on darwin_amd64
+ provider registry.terraform.io/ibm-cloud/ibm v1.41.1


