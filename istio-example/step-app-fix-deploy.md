Создадим секрет client-credential для клиента используя сертификаты и ключ, которые были созданы ранее

```
kubectl create secret generic client-credential \
--from-file=tls.key=client.example.com.key \
--from-file=tls.crt=client.example.com.crt \
--from-file=ca.crt=example.com.crt
```{{execute}}


Добавим ServiceAccount

<pre class="file" data-filename="./internal/app-base" data-target="insert" data-marker="apiVersion: v1">
apiVersion: v1
kind: ServiceAccount
metadata:
  name: sleep
---
</pre>

