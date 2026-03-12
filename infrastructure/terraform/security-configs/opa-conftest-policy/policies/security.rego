package terraform.security

# Все ресурсы должны быть помечены тегами
deny[msg] {
  input.resource_type == "resource"
  not input.config.tags
  msg := sprintf("Resource %s missing tags", [input.resource_name])
}

# S3 bucket должен быть зашифрован
deny[msg] {
  input.resource_type == "aws_s3_bucket"
  not input.config.server_side_encryption_configuration
  msg := sprintf("S3 bucket %s must have encryption enabled", [input.resource_name])
}

# Security Group не должен разрешать 0.0.0.0/0
deny[msg] {
  input.resource_type == "aws_security_group_rule"
  input.config.cidr_blocks[_] == "0.0.0.0/0"
  msg := sprintf("Security Group %s allows ingress from 0.0.0.0/0", [input.resource_name])
}

# EBS диск должен иметь включённое шифрование
deny[msg] {
  input.resource_type == "aws_ebs_volume"
  not input.config.encrypted
  msg := sprintf("EBS volume %s must be encrypted", [input.resource_name])
}

# RDS инстансы должны быть не публичными
deny[msg] {
  input.resource_type == "aws_db_instance"
  input.config.publicly_accessible == true
  msg := sprintf("RDS instance %s must not be publicly accessible", [input.resource_name])
}
