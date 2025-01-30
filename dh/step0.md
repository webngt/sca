`git clone https://github.com/webngt/dh.git`{{execute}}

`cd dh && make run`{{execute}}

[DochubUI]([[UUID_SUBDOMAIN]]-3030-[[HOST]]/)

`curl -X 'PUT' 'https://localhost:3030/core/storage/reload'`

`curl https://localhost:3030/core/storage/jsonata/\(%24\)`