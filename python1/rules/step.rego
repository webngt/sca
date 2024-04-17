package sbercode

# Evaluate at playgroud https://play.openpolicyagent.org/p/6uvoNxv3kZ

# это выражение создает в выходном объекте атрибут allow со значением в виде массива, содержание элемента массива определяется переменной msg
allow[msg] {
	# input[suite] - итератор по ключам входного объекта, на каждой итерации переменной suite присваивается значение ключа соответствующего объекта
	input[suite]
    
    # в объекте suite ожидаем атрибут ok, значением атрибута является массив со массивом названий удачных тестов
    # input[suite].ok[_] - итератор по значениям массива с названиями тестов
    # test := input[suite].ok[_] - значение каждой итерации присваивам переменной test
    # таким образом в переменной тест имеем название успешного теста при каждой итерации
    test := input[suite].ok[_]
    
    # переменной msg присваиваем строковое значение
    msg := sprintf("%s %s: ok", [suite, test])
}

deny[msg] {
	testObj := input[suite].fail[_]
    testObj[testName]
    error := testObj[testName]
    msg := sprintf("%s %s завершился с ошибкой: %s", [suite, testName, error])
}

deny[msg] {
	testObj := input[suite].error[_]
    testObj[testName]
    error := testObj[testName]
    msg := sprintf("%s %s завершился с ошибкой: %s", [suite, testName, error])
}

error[msg] {
	msg := input.error
}