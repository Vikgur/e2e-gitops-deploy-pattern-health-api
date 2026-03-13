storage "raft" {
  path    = "/vault/data"
  node_id = "vault-node"

  retry_join {
    leader_api_addr = "http://vault-0.vault-internal:8200"
  }

  retry_join {
    leader_api_addr = "http://vault-1.vault-internal:8200"
  }

  retry_join {
    leader_api_addr = "http://vault-2.vault-internal:8200"
  }
}