path "auth/kubernetes/config" {
  capabilities = ["create","update"]
}

path "auth/kubernetes/role/*" {
  capabilities = ["create","update","read","delete","list"]
}

path "auth/kubernetes/login" {
  capabilities = ["create","read"]
}