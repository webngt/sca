Выполните следующую команду для запуска кластера и дождитесь ее завершения

```
launch.sh
```{{execute}}

Включим <a href="https://istio.io/latest/docs/setup/additional-setup/sidecar-injection/" target="_blank">istio injection</a> для Namespace default при помощи сделующей команды

```
kubectl label namespace default istio-injection=enabled
```{{execute}}

Таким образом мы обозначили, что Namespace default находится под управлением Istio Service Mesh и готов к развертыванию прикладного сервиса


Также coздайте namespace для размещения внешнего сервиса

```
kubectl create namespace mesh-external
```{{execute}}


