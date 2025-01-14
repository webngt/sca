Для запуска внешнего сервиса необходимо применить в кластере объекты Service и Deployment, которые будут опредлять параметры сетевой доступности внешнего сервера и его рабочего состояния. 

## Примените объекты Service и Deployment

Для этого выполните команду и дождитесь ее завершения

```
kubectl apply -f ./external/svc-deploy-ext.yaml && \
kubectl -n mesh-external wait --for=condition=Ready pod -l run=my-nginx --timeout=-60s
```{{execute}}

**Поздравляем, вы настроили внешний сервис!!!**


## Детальное описание Service и Deployment

Если вы хотите подробнее ознакомиться с объектами Service и Deployment, которые используются для запуска внешнего сервиса, прочитайте информацию ниже.

`external/svc-deploy-ext.yaml`{{open}}

Важные атрибуты объекта Service
* name и namespace - определяют сетевое имя нашего сервера. Совокупность значений этих двух параметров после применения объекта Service даст сетевое имя *my-nginx.mesh-external.svc.cluster.local* (суффикс .svc.cluster.local будет добавлен автомативески при применении объекта). Обратите внимание, что это имя совпадает со значением параметра *server_name* конфигурации сервера, которое мы видели на предыдущем шаге. 
* port со значением 443 в разделе ports говорит о том, что данный сервис будет доступен по порту 443, тк другие параметры не заданы, ожидается, что server в контейнере также будет доступен по порту 443

Важные аттрибуты объекта Deployment

* Обратите внимание на разделы volumes и volumeMounts:
  * volumes определяет имена в соответствии с которыми будут монтироваться объекты Secrect и ConfigMap в файловую систему контейнера
  * volumeMounts определяет имена каталогов контейнера, в которые будут монтироваться файлы конфигурации и секреты, необходимые для работы сервера



