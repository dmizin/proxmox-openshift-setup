# variable "token_id" {
#   type        = string
#   description = "The token created for a user in Proxmox"
#   sensitive   = true
# }

# variable "token_secret" {
#   type        = string
#   description = "The secret created for a user's token in Proxmox"
#   sensitive   = true
# }

variable "TF_VAR_admin_username" {
  description = "User account with create VM rights on Proxmox"
  type = string
}

variable "TF_VAR_admin_password" {
  type = string
  description = "User account with create VM rights on Proxmox"
}

variable "TF_VAR_api_url" {
  type = string
  description = "URL to the API of Proxmox"
}

variable "TF_VAR_target_host" {
  type = string
  description = "PVE host to deploy to"
}

variable "TF_VAR_target_store" {
  type = string
  description = "Storage backing store to deploy to"
}

variable "TF_VAR_hd_size" {
  type        = string
  description = "Boot drive size"
}

variable "TF_VAR_net_bridge" {
  type        = string
  description = "Proxmox Bridge for network"

}

variable "TF_VAR_net_vlan" {
  type        = string
  description = "VLAN for OKD nodes"
}

