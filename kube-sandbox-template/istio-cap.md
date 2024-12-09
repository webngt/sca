В песочнице также предварительно настроен Istio Service Mesh, чтобы вы 
могли создавать более интересные конфигурации. Ниже есть пример такой 
конфигурации.

Напоминаем, что для активации Istio в `namespace` необходимо задать для
этого `namespace` метку (`label`) `istio-injection=enabled`. Ниже приводится
пример создания такого `namespace` с меткой. 

```
kubectl create ns istio-httpbin && \
kubectl label namespace istio-httpbin istio-injection=enabled
```{{execute}}

В песочнице доступна команда `helm`, чтобы вы могли экспериментирвоать с шаблонами запуска (helm charts). Запустите следующую команду. 

```
KUBECONFIG=/etc/rancher/k3s/k3s.yaml helm install httpbin ./istio-httpbin -n istio-httpbin --set sbercodePrefix="$(cat /usr/local/etc/sbercode-prefix)" && \
kubectl -n istio-httpbin wait --for=condition=Ready pod -l app=httpbin --timeout=-60s
```{{execute}}

Одним из параметров запуска является `sbercodePrefix` - уникальный идентификатор для подключения к сервисам запущенным в песочнице из браузера. [Веб доступ к сервису httpbin](https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/)

Пример настройки такой конфигурации с веб доступом к сервису вы можете посмотреть в шаблоне. 

`istio-httpbin/templates/httpbin-istio.yaml`{{open}}
