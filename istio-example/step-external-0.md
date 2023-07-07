Для конфигурации секретов внешнего сервиса необходимо выполнить команды указанные ниже. 

В секретах будут храниться соотвествующие ключи и сертификаты внешнего сервиса, которые вы создали ранее

Создать секрет для хранения сертификата удостоверяющего центра

```
kubectl create -n mesh-external \
  secret generic nginx-ca-certs \
  --from-file=example.com.crt

```{{execute}}


Создать секрет для хранения ключа и сертификата сервиса

```
kubectl create -n mesh-external \
  secret tls nginx-server-certs \
    --key my-nginx.mesh-external.svc.cluster.local.key \
    --cert my-nginx.mesh-external.svc.cluster.local.crt

```{{execute}}
