Чтобы далее можно было предоставить доступ к секрету для объекта DestinationRule, добавим в исходный файл с объектами внешнего сервиса объект Service Account c именем sleep

<pre class="file" data-filename="./internal/app-base.yaml" data-target="insert" data-marker="# Comment SA. Do not edit or remove this line!!!">
apiVersion: v1
kind: ServiceAccount
metadata:
  name: sleep
---
</pre>

Также необходимо добавить указатель на ServiceAccount в объект Deployment

<pre class="file" data-filename="./internal/app-base.yaml" data-target="insert" data-marker="# Comment SA deployemnt. Do not edit or remove this line!!!">
      serviceAccountName: sleep
</pre>

Применим все выполненные изменения

```
kubectl apply -f ./internal/app-base.yaml && \
kubectl wait --for=condition=Ready pod -l app=sleep --timeout=-60s
```{{execute}}


