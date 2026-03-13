path "auth/oidc/config" {
  capabilities = ["create","update","read"]
}

path "auth/oidc/role/*" {
  capabilities = ["create","update","read","delete","list"]
}

path "auth/oidc/login" {
  capabilities = ["create","read"]
}