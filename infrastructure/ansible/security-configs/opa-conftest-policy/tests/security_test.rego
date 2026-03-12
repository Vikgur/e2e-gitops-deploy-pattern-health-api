package ansible.security_test

import data.ansible.security

test_deny_missing_tags {
  input := {"tasks": [{"name": "install packages", "action": "apt"}]}
  security.deny[msg] with input as input
  msg == "Task 'install packages' missing tags"
}

test_deny_shell_without_args {
  input := {"tasks": [{"name": "run raw command", "action": "shell"}]}
  security.deny[msg] with input as input
  msg == "Task 'run raw command' uses shell without args"
}

test_deny_become_true {
  input := {"tasks": [{"name": "restart service", "action": "service", "become": true}]}
  security.deny[msg] with input as input
  msg == "Task 'restart service' must not escalate privileges with become"
}
