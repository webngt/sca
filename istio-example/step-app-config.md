Запустим прикладной сервис. Для этого выполните команду следующую команду и дождитесь ее выполнения.

```
kubectl apply -f ./internal/app-base.yaml && \
kubectl wait --for=condition=Ready pod -l app=sleep --timeout=-60s
```{{execute}}

Эта команда применяет объекты Service и Deployment с минимальным набором параметров необходимых для запуска прикладного сервиса.

## Объекты Service и Deployment

`internal/svc-deploy-ext.yaml`{{open}}

