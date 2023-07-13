Для начала конфигурации внешнего сервиса необходимо создать секреты для хранения ключей и сертификатов внешнего сервиса в кластере Kubernetes. 

Вам понадобятся файлы, которые были созданы ранее:

* example.com.crt
* my-nginx.mesh-external.svc.cluster.local.key
* my-nginx.mesh-external.svc.cluster.local.crt

## Cекрет сертификата удостоверяющего центра

Выполните следующую команду

```
kubectl create -n mesh-external \
  secret generic nginx-ca-certs \
  --from-file=example.com.crt

```{{execute}}

Команда создает *generic secret* в неймспейсе *mesh-external* (опция *-n mesh-external*) из файла *example.com.crt* (опция *--from-file=example.com.crt*)


## Секрет ключа и сертификата сервиса

Выполните следующую команду

```
kubectl create -n mesh-external \
  secret tls nginx-server-certs \
  --key my-nginx.mesh-external.svc.cluster.local.key \
  --cert my-nginx.mesh-external.svc.cluster.local.crt

```{{execute}}

Команда создает *tls secret* в неймспейсе *mesh-external* (опция *-n mesh-external*)

Kлюч берется из файла *my-nginx.mesh-external.svc.cluster.local.key* (опция *--key*), сертификат из файла *my-nginx.mesh-external.svc.cluster.local.crt* (опция *--cert*)
