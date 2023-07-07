Для дальнешего выполнения задания нам понадобятся ключи и сертификаты удостоверяющего центра. 

В корпоративной инфраструктуре обычно этот процесс автоматизирован, но в нашем учебном примере вам придется их выпустить самостоятельно

1. Создать корневой сертификат и приватный ключ

```
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -subj '/O=example Inc./CN=example.com' -keyout example.com.key -out example.com.crt

```{{execute}}

2. Создать сертификат для внешнего сервиса

```
openssl req -out my-nginx.mesh-external.svc.cluster.local.csr -newkey rsa:2048 -nodes -keyout my-nginx.mesh-external.svc.cluster.local.key -subj "/CN=my-nginx.mesh-external.svc.cluster.local/O=some organization"
openssl x509 -req -sha256 -days 365 -CA example.com.crt -CAkey example.com.key -set_serial 0 -in my-nginx.mesh-external.svc.cluster.local.csr -out my-nginx.mesh-external.svc.cluster.local.crt
```{{execute}}

3. Создать сертификат для клиента

```
openssl req -out client.example.com.csr -newkey rsa:2048 -nodes -keyout client.example.com.key -subj "/CN=client.example.com/O=client organization"
openssl x509 -req -sha256 -days 365 -CA example.com.crt -CAkey example.com.key -set_serial 1 -in client.example.com.csr -out client.example.com.crt
```{{execute}}

