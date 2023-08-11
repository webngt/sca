Напоминаем, взаимодействие с Kubernetes осуществляся через терминал и утилиту командной строки `kubectl`

В качестве примера рассмотрим простейший пример запуска сервиса `httpbin` при 
помощи утилиты `kubectl`

```
kubectl apply -f httpbin-kube.yaml && \
kubectl wait --for=condition=Ready pod -l app=httpbin --timeout=-60s
```{{execute}}

Проверка работы сервиса

```
curl http://localhost:30080
```{{execute}}

