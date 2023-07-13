Запустите внешний сервис

```
kubectl apply -f ./external/svc-deploy-ext.yaml && \
kubectl -n mesh-external wait --for=condition=Ready pod -l run=my-nginx --timeout=-60s
```{{execute}}

Запустите прикладной сервис

```
kubectl apply -f ./internal/app-base.yaml && \
kubectl wait --for=condition=Ready pod -l app=sleep --timeout=-60s
```{{execute}}

##  Объекты конфигурации

Если есть необходимость, вы можете ознакомиться с объектами конфигурации. Подробности были рассмотрены в предыдущем упражнении.  

Внешний сервис

`external/svc-deploy-ext.yaml`{{open}}

Внутренний сервис

`internal/app-base.yaml`{{open}}
