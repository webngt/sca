package sbercode

# https://play.openpolicyagent.org/p/HMCX1jMU0y

fmt := concat("", [
`## %s

<details>

### Входные данные

`,
"```", 
`
%s
`,
"```",

`

### Ожидаемый результат

`,
"```",
`
%s
`,
"```",

`
### Фактический результат

`,
"```",
`
%s
`,
"```",
])


errFmt := concat("", [
`## %s

<details>

### Непредвиденая ошибка

`,
"```", 
`
%s
`,
"```",
])

allow[msg] {
    test := input[key]
    test.passed
    msg := sprintf(fmt, [key, concat(",\n", test.input), concat(",\n", test.result), concat(",\n", test.expected)])
}

deny[msg] {
    test := input[key]
    not(test.passed)
    
    msg := sprintf(fmt, [key, concat(",\n", test.input), concat(",\n", test.result), concat(",\n", test.expected)])
}

error[msg] {
	test := input[key]
    test.error != null
    msg := sprintf(errFmt, [key, test.error])
}