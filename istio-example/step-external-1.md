Для конфигурации внешнего сервиса выполните пункты, указанные ниже

## Ознакомьтесь с конфигурацией внешнего сервиса

`external/nginx.conf`{{open}}

## Cоздайте Kubernetes ConfigMap из конфиг файла предыдущего шага

```
kubectl create configmap \
  nginx-configmap -n mesh-external \
  --from-file=nginx.conf=./external/nginx.conf
```{{execute}}
