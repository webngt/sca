Выполните следующие команды, которые создадут роль client-credential-role и сделают ее привязку к ServiceAccount

```
kubectl create role client-credential-role --resource=secret --verb=get,list,watch
kubectl create rolebinding client-credential-role-binding --role=client-credential-role --serviceaccount=default:sleep
```{{execute}}

## Объект Destination Rule

`internal/app-dr.yaml`{{open}}

Описание ключевых параметров указаны в комментариях в файле

Примените правило

```
kubectl apply -f internal/app-dr.yaml
```{{execute}}



