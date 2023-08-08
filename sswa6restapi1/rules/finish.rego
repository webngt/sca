package sbercode

# 1 ---------------------------------------------------------------------------------------

# правило на налифиче факта запуска curl -v localhost:32100/httpbin/ip
allow[msg] {                                                                                                           
  input.didIpRequest == "true"
  msg := "поздравляем, похоже, что вы запустили curl -v localhost:32100/httpbin/ip"
}

# правило на отсутствие факта запуска curl -v localhost:32100/httpbin/ip
deny[msg] {                                                                                                           
  input.didIpRequest == "false"
  msg := "к сожалению, мы не смогли найти следов запуска curl -v localhost:32100/httpbin/ip"
}

# 2 ---------------------------------------------------------------------------------------

# правило на налифиче факта запуска curl -v localhost:32100/httpbin/html
allow[msg] {                                                                                                           
  input.didHtmlRequest == "true"
  msg := "поздравляем, похоже, что вы запустили curl -v localhost:32100/httpbin/html"
}

# правило на отсутствие факта запуска curl -v localhost:32100/httpbin/html
deny[msg] {                                                                                                           
  input.didHtmlRequest == "false"
  msg := "к сожалению, мы не смогли найти следов запуска curl -v localhost:32100/httpbin/html"
}

# 3 ---------------------------------------------------------------------------------------

# правило на налифиче факта запуска curl -v localhost:32100/httpbin/delay/5
allow[msg] {                                                                                                           
  input.didDelayRequest == "true"
  msg := "поздравляем, похоже, что вы запустили curl -v localhost:32100/httpbin/delay/5"
}

# правило на отсутствие факта запуска curl -v localhost:32100/httpbin/delay/5
deny[msg] {                                                                                                           
  input.didDelayRequest == "false"
  msg := "к сожалению, мы не смогли найти следов запуска curl -v localhost:32100/httpbin/delay/5"
}

# 4 ---------------------------------------------------------------------------------------

# правило на налифиче факта запуска curl -v -XPOST localhost:32100/httpbin/post -H "Content-Type: application/json" -d'{"data":"test data here"}'
allow[msg] {                                                                                                           
  input.didPostRequest == "true"
  msg := "поздравляем, похоже, что вы запустили curl -v -XPOST localhost:32100/httpbin/post -H \"Content-Type: application/json\" -d'{\"data\":\"test data here\"}'"
}

# правило на отсутствие факта запуска curl -v -XPOST localhost:32100/httpbin/post -H "Content-Type: application/json" -d'{"data":"test data here"}'
deny[msg] {                                                                                                           
  input.didPostRequest == "false"
  msg := "к сожалению, мы не смогли найти следов запуска curl -v -XPOST localhost:32100/httpbin/post -H \"Content-Type: application/json\" -d'{\"data\":\"test data here\"}'"
}

# 5 ---------------------------------------------------------------------------------------

# правило на успешный запуск кубера и ингрес контроллера
allow[msg] { 
  # есть ли вообще массив controllerStatus.items c количеством элементов 1
  count(input.controllerStatus.items) == 1
  # есть ли вообще массив controllerStatus.items[0].conditions c количеством элементов 4
  count(input.controllerStatus.items[0].status.conditions) = 4
  # проверяем статус запуска контейнера ингрес контроллра
  input.controllerStatus.items[0].status.conditions[_].status = "True"

  msg := "поздравляем, похоже, что вы успешно инициализировали кубернетс и ингресс контроллер"
}


# правило на отсуствие признаков запуска кубера и ингрес контролера
deny[msg] { 
  count(input.controllerStatus.items) == 0
  msg := "к сожалению, мы не смогли найти следов запуска вами кубера и ингресс контроллера (см первый шаг упражнения и команду prepare.sh)"
}

# 6 ---------------------------------------------------------------------------------------

# ошибка, если запрос к kubectl свалился с ошибкой
error[msg] {                                      
  input.controllerStatus.error
  msg := sprintf("невозможно завершить упражнение, обратитесь в поддержку или к автору курса: %s", [input.controllerStatus.error])
}


# ошибка, неожиданное состояние кластерв
error[msg] {                                      
  count(input.controllerStatus.items) > 1
  msg := sprintf("невозможно завершить упражнение, обратитесь в поддержку или к автору курса, неожиданное состояние кластера кубера: %v", [input.controllerStatus])  
}

# ошибка, неожиданное состояние кластерв
error[msg] {                                      
  count(input.controllerStatus.items) == 1
  not(input.controllerStatus.items[0].status)
  msg := sprintf("невозможно завершить упражнение, обратитесь в поддержку или к автору курса, неожиданное состояние кластера кубера: %v", [input.controllerStatus])  
}


# общее правило на непредвиденную ошибку
error[msg] {                                                                                                           
  msg := input.error
}
