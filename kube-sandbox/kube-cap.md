## Работа с Kubernetes

Напоминаем, взаимодействие с Kubernetes осуществляся через терминал и утилиту командной строки `kubectl`

В качестве примера рассмотрим простейший пример запуска `httpbin` при 
помощи утилиты `kubectl`

```
kubectl apply -f kube/httpbin.yaml
```{{execute}}

