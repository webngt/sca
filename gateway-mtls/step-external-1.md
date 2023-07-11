Загрузим конфигурацйю внешнего сервиса в виде объекта ConfigMap

Для этого выполните следующую команду:

```
kubectl create configmap \
  nginx-configmap -n mesh-external \
  --from-file=nginx.conf=./external/nginx.conf
```{{execute}}

## Ознакомьтесь с конфигурацией внешнего сервиса

Обратите внимание, что при выполнении команды, источником информации является файл ./external/nginx.conf. В этом файле определены основные параметры работы внешнего сервиса.

`external/nginx.conf`{{open}}

Важные параметры конфигурации

* listen 443 ssl; - определяет по какому порту и протоколу будет доступен сервер
* server_name my-nginx.mesh-external.svc.cluster.local; - доменное имя сервера
* указатели на файлы, откуда сервер возьмет сертификаты и ключи
  * ssl_certificate /etc/nginx-server-certs/tls.crt;
  * ssl_certificate_key /etc/nginx-server-certs/tls.key;
  * ssl_client_certificate /etc/nginx-ca-certs/example.com.crt;
* ssl_verify_client on; - сервер будет проверять клиентский сертификат

Эти параметры определяют основные критерии, которым должны соотвествовать запросы к внешнему сервису
* запросы должны идти по защищенному соединению
* при получении запроса необходимо проверять валидность сертификата отправителя

