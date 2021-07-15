# Terraform » Ansible Learning Repo, which integrates with vSphere and Azure
**(especially for Windows)**

`basic` directores 
- basic usage of Ansible and Terraform

`advanced` directory
- auto-configure Windows to be accessible using WinRM and SSH connections
- uses of terraform `local_file` to generate a dynamic ansible inventory file 

## Requirements

- make sure to have an azure service principal available, which owns `Contributor Role` in an Azure subscription.
- make sure to rename all `terraform.tfvars.sample` files to `terraform.tfvars` and adjust your credential information. 
- in terraform/basic/vsphere` and `terraform/advance/vsphere` adjust the `variables.tf` and `main.tf` accordingly to fit into your vSphere environment.

## Basic Usage

**vSphere**

1. Provision VM using terraform
```bash
cd terraform/basic/vsphere
terraform init
terraform plan
terraform appy
```
2. Make sure to enable SSH on the Windows VM    
Example: https://raw.githubusercontent.com/andif888/powershell-win-openssh-server/master/enable-win-openssh-server.ps1   
(**!!!** make sure to replace the contained SSH public key with your own public key)   

3. Enter IP address of the VM into [ansible/basic/environment/vsphere/inventory/static_inventory](ansible/basic/environment/vsphere/inventory/static_inventory)   

4. configure VM using ansible
```bash
cd ansible
ansible-playbook -i basic/environment/vsphere/inventory playbook_windows_feature.yml
```

**Azure**

1. Provision VM using terraform
```bash
cd terraform/basic/azure
terraform init
terraform plan
terraform appy
```
2. Make sure to enable SSH on the Windows VM    
Example: https://raw.githubusercontent.com/andif888/powershell-win-openssh-server/master/enable-win-openssh-server.ps1   
(**!!!** make sure to replace the contained SSH public key with your own public key)     

3. Enter IP address of the VM into [ansible/basic/environment/azure/inventory/static_inventory](ansible/basic/environment/azure/inventory/static_inventory)    

4. configure VM using ansible
```bash
cd ansible
ansible-playbook -i basic/environment/azure/inventory playbook_windows_feature.yml
```

## Advanced Usage

make sure to replace the scripts, which automate SSH Server configuration with your own ones. Otherwise I will have access to your VMs, because those scripts contain my SSH public key:  
1. [terraform/advanced/azure/files/ConfigureRemotingForAnsible.bat](terraform/advanced/azure/files/ConfigureRemotingForAnsible.bat)
2. [terraform/advance/vsphere/main.tf](terraform/advance/vsphere/main.tf) Line 71  
```hcl
run_once_command_list = ["cmd.exe /C powershell.exe -NoProfile -ExecutionPolicy Bypass -Command \"[Net.ServicePointManager]::SecurityProtocol = 'Tls12'; iex ((New-Object System.Net.Webclient).DownloadString('https://raw.githubusercontent.com/andif888/run_once_cmd/master/1.ps1'))\""] 
```

**vSphere**

1. Provision VM using terraform
```bash
cd terraform/advanced/vsphere
terraform init
terraform plan
terraform appy
```
  
2. configure VM using ansible
```bash
cd ansible
ansible-playbook -i advanced/environment/vsphere/inventory playbook_windows_feature.yml
```

**Azure**

1. Provision VM using terraform
```bash
cd terraform/advanced/azure
terraform init
terraform plan
terraform appy
```  
2. configure VM using ansible
```bash
cd ansible
ansible-playbook -i advanced/environment/azure/inventory playbook_windows_feature.yml
```
