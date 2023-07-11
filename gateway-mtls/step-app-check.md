Проверим, как теперь выполняется запрос

```
kubectl exec "$(kubectl get pod -l app=sleep -o jsonpath={.items..metadata.name})" -c sleep -- curl -sIS http://my-nginx.mesh-external.svc.cluster.local:443
```{{execute}}

Если вы видите такую информацию в терминале после выполнения команды, то это означает, что запрос от прикладного сервиса дошел до внешнего сервиса, при этом Sidecar успешно выполнил задачу установки защищенного MTLS соединения с внешним сервером.

```
HTTP/1.1 200 OK
server: envoy
date: Tue, 11 Jul 2023 19:48:38 GMT
content-type: text/html
content-length: 615
last-modified: Tue, 13 Dec 2022 15:53:53 GMT
etag: "6398a011-267"
accept-ranges: bytes
x-envoy-upstream-service-time: 3
```


