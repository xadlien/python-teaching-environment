# Python Teaching Environment
## Description
This repository holds the necessary code to initialize a python teaching environment in digital ocean. More work needs to be done to have ansible distribute class files.
## Setup
### Update Some Values
There are two things that need to be checked before running.
1. Ensure that the ssh_keys value is your own ssh_key id from Digital Ocean.
2. After applying the terraform ensure you update the inventory with the IP address given.
3. Update the user passwords in the `ansible/group_vars/jupyterhub.yml` file.
```
# to create a password encrypted with ansible-vault
echo -n "newpass" | ansible-vault encrypt_string

# then copy the output to the file.
```
### Create server
```
cd terraform/network
terraform init
terraform apply
cd ..
terraform init 
terraform apply
cd ..
```
### Setup Jupyterhub
```
cd ansible
ansible-playbook -u root -i development playbooks/jupyterhub.yml --ask-vault-pass
```