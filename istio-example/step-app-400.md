Проверим связь между прикладным контейнером и внешним сервисом. Для этого выполните команду.

```
kubectl exec \
"$(kubectl get pod -l app=sleep -o jsonpath={.items..metadata.name})" \
-c sleep -- curl -svS http://my-nginx.mesh-external.svc.cluster.local:443
```{{execute}}

## Что происходит?

![App_](./assets/400.png)