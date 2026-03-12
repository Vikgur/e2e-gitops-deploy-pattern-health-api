package ansible.security

# Каждый таск должен иметь тег
deny[msg] {
  task := input.tasks[_]
  not task.tags
  msg := sprintf("Task '%s' missing tags", [task.name])
}

# Использование shell без явно заданных args запрещено
deny[msg] {
  task := input.tasks[_]
  task.action == "shell"
  not task.args
  msg := sprintf("Task '%s' uses shell without args", [task.name])
}

# По умолчанию запрещаем become: true (кроме явно разрешённых)
deny[msg] {
  task := input.tasks[_]
  task.become == true
  not task.allow_become
  msg := sprintf("Task '%s' must not escalate privileges with become", [task.name])
}
