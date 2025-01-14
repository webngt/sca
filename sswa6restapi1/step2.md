### Пример запросов с методом GET
  
Выполним GET запрос:
`curl -v localhost:32100/httpbin/ip`{{execute}}

Это команда выполняет HTTP GET запрос на локальный хост и порт 32100, используя утилиту curl.

Давайте рассмотрим каждый аргумент и его роль в команде:

* -v: Включает подробный вывод (verbose), который отображает дополнительную информацию о выполнении запроса и полученном ответе.
* localhost:32100/httpbin/ip: Указывает URL, на который будет выполнен запрос. В данном случае, запрос будет отправлен на httpbin/ip на локальный хост с портом 32100.

Это команда выполняет GET запрос на указанный URL. В результате выполнения команды, вы увидите подробную информацию о запросе и полученном ответе.

httpbin/ip является адресом, предоставляемым сервисом httpbin, который возвращает информацию об IP-адресе, с которого выполнен запрос. Вы получите ответ, содержащий информацию об IP-адресе клиента, который инициировал запрос.

Таким образом, данная команда позволяет получить информацию об IP-адресе клиента, отправляющего запрос на указанный URL.

Выполним GET запрос:
`curl -v localhost:32100/httpbin/html`{{execute}}

В ответе запроса получаем пример HTML страницы.

Выполним GET запрос:
`curl -v localhost:32100/httpbin/delay/5`{{execute}}

В ответе запроса получаем некоторые данные в виде JSON, но с задержкой ответа в 5 секунд.

### Пример запросов с методом POST

Выполним POST запрос:
`curl -v -XPOST localhost:32100/httpbin/post -H "Content-Type: application/json" -d'{"data":"test data here"}'`{{execute}}

Это команда выполняет HTTP POST запрос на локальный хост и порт 32100, используя утилиту curl.

Давайте разберем каждый аргумент и его роль в команде:
* -v: Включает подробный вывод (verbose), который отображает дополнительную информацию о выполнении запроса и полученном ответе.
* -XPOST: Определяет метод запроса как POST.
* localhost:32100/httpbin/post: Указывает URL, на который будет выполнен запрос. В данном случае, запрос будет отправлен на httpbin/post на локальный хост с портом 32100.
* -H "Content-Type: application/json": Устанавливает заголовок запроса "Content-Type" со значением "application/json". Этот заголовок сообщает серверу, что тело запроса представлено в формате JSON.
* -d '{"data":"test data here"}': Устанавливает тело запроса. В данном случае, отправляется JSON-объект {"data":"test data here"} в качестве тела запроса.

В качестве ответа сервер вернет JSON с данными, переданными в теле запроса. 

При попытке выполнить данный запрос без явного указания типа POST(-XPOST) будет выполнен запрос типа GET, который вернет ошибку `405 Method Not Allowed`


При желании можно самостоятельно поэкспериментировать с другими типами запросов согласно спецификации.