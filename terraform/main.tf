resource "proxmox_virtual_environment_vm" "vms" {
  for_each = var.virtual_machines
  name        = each.key
  node_name   = "server" # Твой узел в Proxmox
  #vm_id       = 101

  # Клонируем из твоего готового шаблона 9000
  clone {
    vm_id = 9001
    full  = false # Мгновенный Linked Clone
  }
  
# Включаем гостевой агент (мост связи Proxmox <-> Ubuntu)
  agent {
    enabled = true
    timeout = "60s" # OpenTofu подождет до 60 секунд, пока агент в Linux проснется!
  }

  cpu {
    cores = each.value.cores
    type  = "host"
  }

  memory {
    dedicated = each.value.memory
    floating  = each.value.memory / 2 # Включает ballooning! Минимум 50% ГБ
  }
  network_device {
    bridge = "vmbr0"
  }
  disk {
    datastore_id = "local-lvm"
    interface   = "scsi0"
    size        = each.value.disk_size
  }
  # Передаем настройки в ОС через Cloud-Init
  initialization {
    ip_config {
      ipv4 {
        # address = "dhcp" 
        address = each.value.ip_address # Твой желаемый IP (обязательно с /24 в конце!)
        gateway = "192.168.1.1"      # IP твоего роутера (шлюз)
      }
    }
    user_account {
      username = "ubuntu"
        keys = [for key in var.ssh_public_key : trimspace(key)]

    }
  }
  started = true
}

# tofu init — скачать плагины провайдеров.
# tofu apply — поднять сервер за 15 секунд.
# tofu destroy — стереть его и освободить место, когда закончил эксперименты.
# tofu plan - Show changes required by the current configuration