variable "vmName" { default = "VM-LINUX" }
variable "rgName" { default = "RG-az303MOD05" }
variable "environment" { default = "loadbalance" }
variable "location" { default = "eastus" }
variable "faultdomain" { default = "3" }
variable "updatedomain" { default = "5" }
variable "owner" { default = "Terraform" }
variable "numVMS" { default = 2 }
variable "application_port" { default = 22 }

