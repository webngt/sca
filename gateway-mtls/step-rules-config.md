Создать объект Gateway

```
kubectl apply -f internal/gateway.yaml
```{{execute}}

Создать DestinationRule для участка Sidecar->Egress Gateway, оно будет работать на сайдкарах в неймспейсе default

```
kubectl apply -f internal/dr-sidecar-gateway.yaml
```{{execute}}

Создать DestinationRule для участка Egress Gateway->Внешний сервис. *Обратите внимание, что это правило создается в неймспейсе istio-system, тк шлюз был запущен в именно там*

```
kubectl -n istio-system apply -f internal/dr-gateway-external.yaml
```{{execute}}

Создать VirtualService

```
kubectl apply -f internal/virtual-service.yaml
```{{execute}}

## Подробнее о заоданных объектах

Откройте файлы в редакторе и ознакомьтесь с важными атрибутами в комментариях

`internal/gateway.yaml`{{open}}

`internal/dr-sidecar-gateway.yaml`{{open}}

`internal/dr-gateway-external.yaml`{{open}}

`internal/virtual-service.yaml`{{open}}
