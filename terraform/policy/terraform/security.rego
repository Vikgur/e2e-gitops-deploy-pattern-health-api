package terraform.security

deny[msg] {
  some r
  input.resource_changes[r].type == "yandex_vpc_security_group_rule"
  input.resource_changes[r].change.after.v4_cidr_blocks[_] == "0.0.0.0/0"
  msg := "Запрещён 0.0.0.0/0 в security group"
}

deny[msg] {
  some r
  input.resource_changes[r].type == "yandex_storage_bucket"
  flags := input.resource_changes[r].change.after.anonymous_access_flags
  flags.read
  msg := "Запрещены публичные бакеты в Object Storage"
}

deny[msg] {
  some r
  input.resource_changes[r].type == "yandex_storage_bucket"
  not input.resource_changes[r].change.after.server_side_encryption_configuration
  msg := "Бакет без SSE-KMS"
}

deny[msg] {
  some r
  input.resource_changes[r].type == "yandex_compute_instance"
  labels := input.resource_changes[r].change.after.labels
  (labels.Owner == "" or labels.Env == "" or labels.CostCenter == "")
  msg := "Отсутствуют обязательные теги Owner/Env/CostCenter на VM"
}

warn[msg] {
  not input.configuration.provider_config.yandex.version
  msg := "Провайдер yandex без фиксированной версии (versions.tf)"
}
