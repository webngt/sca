package sbercode

fmt := `## %s

<details>

### Входные данные

```
2
3
```

### Ожидаемый результат

```
Произведение = %s
```

### Фактический результат

```
Произведение = %s
```

</details>
`



allow[msg] {
	test := input[key]
    test.passed
    msg := sprintf("*%s* выполнены условия теста\n ожидаемый результат: %s, \nфактический результат %s", [key, test.result[0], test.expected[0]])
}

deny[msg] {
	test := input[key]
    not(test.passed)
    
    msg := sprintf(fmt, [key, test.result[0], test.expected[0]])
}

error[msg] {
	test := input[key]
    test.error != null
    msg := sprintf("*%s* непредвиденная ошибка: %s", [key, test.error])
}