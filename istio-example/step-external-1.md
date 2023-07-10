Для конфигурации внешнего сервиса выполните пункты, указанные ниже

## Ознакомьтесь с конфигурацией внешнего сервиса

`external/nginx.conf`{{open}}

Важные параметры конфигурации

* listen 443 ssl; - определяет по какому порту и протоколу будет доступен сервер
* server_name my-nginx.mesh-external.svc.cluster.local; - доменное имя сервера
* указатели на файлы, откуда сервер возьмет сертификаты и ключи
  * ssl_certificate /etc/nginx-server-certs/tls.crt;
  * ssl_certificate_key /etc/nginx-server-certs/tls.key;
  * ssl_client_certificate /etc/nginx-ca-certs/example.com.crt;
* ssl_verify_client on; - сервер будет проверять клиентский сертификат


## Cоздайте Kubernetes ConfigMap 

Чтобы указанной конфигурацией можно было пользоваться внутри кластера Kubernetes, необходимо ее загрузить в виде объекта ConfigMap

Для этого выполните следующую команду:

```
kubectl create configmap \
  nginx-configmap -n mesh-external \
  --from-file=nginx.conf=./external/nginx.conf
```{{execute}}
