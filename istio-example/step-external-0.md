Для конфигурации секретов внешнего сервиса необходимо выполнить команды указанные ниже. 

В секретах будут храниться соотвествующие ключи и сертификаты внешнего сервиса, которые вы создали ранее

## Cекрет сертификата удостоверяющего центра

Выполните следующую команду

```
kubectl create -n mesh-external \
  secret generic nginx-ca-certs \
  --from-file=example.com.crt

```{{execute}}

Команда создает generic secret в неймспейсе mesh-external (опция -n mesh-external) из файла example.com.crt (опция --from-file=example.com.crt) 


Создать секрет для хранения ключа и сертификата сервиса

```
kubectl create -n mesh-external \
  secret tls nginx-server-certs \
    --key my-nginx.mesh-external.svc.cluster.local.key \
    --cert my-nginx.mesh-external.svc.cluster.local.crt

```{{execute}}

Команда создает tls secret в неймспейсе mesh-external (опция -n mesh-external), ключ берется из файла my-nginx.mesh-external.svc.cluster.local.key (опция --key), сертификат из файла my-nginx.mesh-external.svc.cluster.local.crt (опция --cert)
