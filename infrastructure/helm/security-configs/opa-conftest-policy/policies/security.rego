package helm.security

# replicaCount обязателен и >= 2 (HA best practice)
deny[msg] {
  not input.replicaCount
  msg := "Missing replicaCount in values.yaml"
}
deny[msg] {
  input.replicaCount < 2
  msg := "replicaCount must be >= 2 for HA"
}

# image.tag не должен быть latest
deny[msg] {
  endswith(input.image.tag, "latest")
  msg := "Image tag must not be 'latest'"
}

# resources обязаны быть заданы
deny[msg] {
  not input.resources.requests.cpu
  msg := "Missing CPU request in values.yaml"
}
deny[msg] {
  not input.resources.limits.cpu
  msg := "Missing CPU limit in values.yaml"
}
deny[msg] {
  not input.resources.requests.memory
  msg := "Missing memory request in values.yaml"
}
deny[msg] {
  not input.resources.limits.memory
  msg := "Missing memory limit in values.yaml"
}
