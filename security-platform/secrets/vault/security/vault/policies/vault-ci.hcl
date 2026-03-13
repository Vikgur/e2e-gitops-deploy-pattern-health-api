path "secret/data/ci/*" {
  capabilities = ["create","read","update","delete","list"]
}

path "secret/metadata/ci/*" {
  capabilities = ["list"]
}

path "auth/token/create" {
  capabilities = ["create","update"]
}