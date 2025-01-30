package sbercode

allow[msg] {
    count(input) == 0
	msg := "ok"
}

deny[msg] {
    msg := input[_]
}