package helm.security_test

import data.helm.security

test_deny_missing_replicaCount {
  input := {"image": {"tag": "1.0.0"}}
  security.deny[msg] with input as input
  msg == "Missing replicaCount in values.yaml"
}

test_deny_low_replicaCount {
  input := {"replicaCount": 1, "image": {"tag": "1.0.0"}}
  security.deny[msg] with input as input
  msg == "replicaCount must be >= 2 for HA"
}

test_deny_latest_tag {
  input := {"replicaCount": 2, "image": {"tag": "latest"}, "resources": {"requests": {"cpu": "100m", "memory": "128Mi"}, "limits": {"cpu": "500m", "memory": "256Mi"}}}
  security.deny[msg] with input as input
  msg == "Image tag must not be 'latest'"
}

test_deny_missing_resources {
  input := {"replicaCount": 2, "image": {"tag": "1.0.0"}, "resources": {"requests": {}, "limits": {}}}
  security.deny[msg] with input as input
  count(security.deny) > 0
}
