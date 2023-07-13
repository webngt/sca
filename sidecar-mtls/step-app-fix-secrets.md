Создадим секрет client-credential для клиента используя сертификат сервера, сертификат и ключ клиента, которые были созданы ранее

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

