Напоминаем, взаимодействие с Kubernetes осуществляся через терминал и утилиту командной строки `kubectl`

В качестве примера рассмотрим простейший пример запуска сервиса `httpbin` при 
помощи утилиты `kubectl`

```
kubectl apply -f httpbin-kube.yaml && \
kubectl wait --for=condition=Ready pod -l app=httpbin --timeout=-60s
```{{execute}}

Проверка работы сервиса

```
curl -I http://localhost:30080
```{{execute}}


Ознакомьтесь с конфигурацией примера

`httpbin-kube.yaml`{{open}}

В вашей самостоятельной работе вым могут потребоваться докер образы, вы можете
использовать любой из официальных образов dockehub, см 

<a href="https://hub.docker.com/search?q=&image_filter=official" target="_blank" rel="noopener noreferrer">https://hub.docker.com/search?q=&image_filter=official</a>


