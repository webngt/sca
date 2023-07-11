Создадим секрет client-credential для клиента используя сертификаты и ключ, которые были созданы ранее

```
kubectl create secret generic client-credential \
--from-file=tls.key=client.example.com.key \
--from-file=tls.crt=client.example.com.crt \
--from-file=ca.crt=example.com.crt
```{{execute}}

Добавим секрет в объект Deployment внешнего сервиса


<pre class="file" data-filename="./internal/app-base.yaml" data-target="insert" data-marker="# Comment Secrets. Do not edit or remove this line!!!">
        volumeMounts:
        - mountPath: /etc/sleep/tls
          name: secret-volume
      volumes:
      - name: secret-volume
        secret:
          secretName: sleep-secret
          optional: true
</pre>


Чтобы далее можно было предоставить доступ к секрету для объекта DestinationRule, добавим в исходный файл с объектами внешнего сервиса объект Service Account

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

