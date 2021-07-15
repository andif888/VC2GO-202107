# Azure Shared
variable "azure_subscription_id" {
    # override in terraform.tfvars
    type = string
    default = ""
    description = "Azure Subscription ID. In Azure Portal click Cost Management + Billing. Here you find your asigned Subscription ID"
}
variable "azure_client_id" {
    # override in terraform.tfvars
    type = string
    default = ""
    description = "Azure Client ID. This is the Application ID of the registered App in Azure Portal"
}
variable "azure_client_secret" {
    # override in terraform.tfvars
    type = string
    default = ""
    description = "Azure Client Secret. This is the key's password value of the registered App in the Azure Portal"
}
variable "azure_tenant_id" {
    # override in terraform.tfvars
    type = string
    default = ""
    description = "Azure Tenant ID. In Azure Portal click Azure Active Directory -> Properties an note th Directory ID"
}
variable "azure_vm_admin_username" {
    type = string
    default = "a-bot"
}
variable "azure_vm_admin_password" {
    type = string
    default = "Vagrant8983(33)33"
}
