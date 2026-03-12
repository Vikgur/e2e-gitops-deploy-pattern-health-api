plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

# При необходимости — явная настройка отдельных правил
rule "terraform_required_providers" { enabled = true }
rule "terraform_deprecated_index"  { enabled = true }
rule "terraform_naming_convention" { enabled = true }
