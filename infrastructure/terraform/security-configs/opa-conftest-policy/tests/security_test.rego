package terraform.security_test

import data.terraform.security

test_deny_missing_tags {
  input := {"resource_type": "resource", "resource_name": "vm1", "config": {}}
  security.deny[msg] with input as input
  msg == "Resource vm1 missing tags"
}

test_deny_s3_unencrypted {
  input := {"resource_type": "aws_s3_bucket", "resource_name": "bucket1", "config": {}}
  security.deny[msg] with input as input
  msg == "S3 bucket bucket1 must have encryption enabled"
}

test_deny_sg_open {
  input := {"resource_type": "aws_security_group_rule", "resource_name": "sg_rule", "config": {"cidr_blocks": ["0.0.0.0/0"]}}
  security.deny[msg] with input as input
  msg == "Security Group sg_rule allows ingress from 0.0.0.0/0"
}

test_deny_rds_public {
  input := {"resource_type": "aws_db_instance", "resource_name": "db1", "config": {"publicly_accessible": true}}
  security.deny[msg] with input as input
  msg == "RDS instance db1 must not be publicly accessible"
}
