## Клонировать условно работающий пример

`git clone https://github.com/webngt/dh.git`{{execute}}

## Запустить пример

```
cd dh && \
docker run \
-p 3030:3030 \
-v /root/dh/ceaf-app:/app/public/ceaf-app \
-v /root/dh/example.env:/app/.env \
--name dochub -d docker.io/alexander894/dochub:0.0.1
```{{execute}}

[DochubUI]([[UUID_SUBDOMAIN]]-3030-[[HOST]]/)

Запрос релоада `fetch('/core/storage/reload', {method: 'PUT'})`


Запрос схемы `fetch('/core/storage/jsonata/\(%24\)')`