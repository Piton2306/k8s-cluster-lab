output "vms_ips" {
  description = "IP-адреса созданных серверов"
  value = {
    for k, v in proxmox_virtual_environment_vm.vms : k => try(v.ipv4_addresses[1][0], "IP получается...")
  }
}