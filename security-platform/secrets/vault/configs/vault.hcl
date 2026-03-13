ui = true

cluster_name = "vault-cluster"

disable_mlock = true

api_addr     = "http://0.0.0.0:8200"
cluster_addr = "http://0.0.0.0:8201"

log_level = "info"

listener "tcp" {
  address       = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"

  tls_disable = 1

  telemetry {
    unauthenticated_metrics_access = true
  }
}

include "storage.hcl"
include "audit.hcl"
include "telemetry.hcl"