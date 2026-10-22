variable "virtual_environment_endpoint" {
  description = "Адрес веб-интерфейса Proxmox"
  type        = string
}

variable "virtual_environment_api_token" {
  description = "Секретный токен доступа к API Proxmox"
  type        = string
  sensitive   = true # Это слово скрывает твой токен звёздочками в логах консоли!
}

variable "ssh_public_key" {
  type        = list(string)
  description = "Список публичных SSH-ключей для входа в созданную ВМ"
}

variable "virtual_machines" {
  type = map(object({
    ip_address = string
    cores      = number
    memory     = number
    disk_size  = number
  }))
  description = "Параметры создаваемых виртуальных машин"
}