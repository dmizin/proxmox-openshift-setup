terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc1"
    }
  }
}

provider "proxmox" {
  pm_api_url  = var.TF_VAR_api_url
  pm_user     = var.TF_VAR_admin_username
  pm_password = var.TF_VAR_admin_password
  # pm_api_token_id     = var.token_id
  # pm_api_token_secret = var.token_secret
  # Leave to "true" for self-signed certificates
  pm_tls_insecure = "true"
  pm_log_enable = true
  pm_log_file   = "terraform-plugin-proxmox.log"
  pm_debug      = true
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}

locals {
  vm_settings = {
    "master0"      = { macaddr = "7A:00:00:00:03:01", cores = 4, ram = 16384, vmid = 801, os = "pxe-client", boot = false },
    "master1"      = { macaddr = "7A:00:00:00:03:02", cores = 4, ram = 16384, vmid = 802, os = "pxe-client", boot = false },
    "master2"      = { macaddr = "7A:00:00:00:03:03", cores = 4, ram = 16384, vmid = 803, os = "pxe-client", boot = false },
    "worker0"      = { macaddr = "7A:00:00:00:03:04", cores = 2, ram = 16384, vmid = 804, os = "pxe-client", boot = false },
    "worker1"      = { macaddr = "7A:00:00:00:03:05", cores = 2, ram = 16384, vmid = 805, os = "pxe-client", boot = false },
    "worker2"      = { macaddr = "7A:00:00:00:03:06", cores = 2, ram = 16384, vmid = 806, os = "pxe-client", boot = false },
    "bootstrap"    = { macaddr = "7A:00:00:00:03:07", cores = 4, ram = 16384, vmid = 807, os = "pxe-client", boot = false },
    "okd-services" = { macaddr = "7A:00:00:00:03:08", cores = 4, ram = 16384, vmid = 808, os = "a2cent", boot = true }
  }
}

/* Configure cloud-init User-Data with custom config file */
resource "proxmox_vm_qemu" "cloudinit-nodes" {
  for_each    = local.vm_settings
  name        = each.key
  vmid        = each.value.vmid
  target_node = var.TF_VAR_target_host
  clone       = each.value.os
  full_clone  = true
  boot        = "order=scsi0;ide2;net0" # "c" by default, which renders the coreos35 clone non-bootable. "cdn" is HD, DVD and Network
  oncreate    = each.value.boot         # start once created
  agent       = 1

  cores    = each.value.cores
  memory   = each.value.ram
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"
  hotplug  = 0

    disks {
        virtio {
            virtio0 {
                disk {
                    size            = var.TF_VAR_hd_size
                    cache           = "writeback"
                    storage         = var.TF_VAR_target_store
                    #storage_type    = "rbd"
                    iothread        = true
                    discard         = true
                }
            }
        }
    }

  network {
    model   = "virtio"
    bridge  = var.TF_VAR_net_bridge
    #tag     = var.TF_VAR_net_vlan
    macaddr = each.value.macaddr
  }
}
