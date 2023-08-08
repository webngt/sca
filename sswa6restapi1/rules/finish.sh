#!/bin/bash

#
# Скрипт сбора фактов активности студента
#

# функция проверяет наличие заданного шаблона в логе ингреса
#
# в переменной $1 передаем содержимое лога
# в переменной $2 передаем шаблон
function lookupIngressLogs {
    while read line; do
        if [[ $line =~ $2 ]] ;then
            echo "true"
            return
        fi
    done <<< "$1"

    echo "false"
    return
}

# проверим, запускал ли пользователь prepare.sh ожидаем увидеть работающий ingress
controllerStatus=$(kubectl get po -l app.kubernetes.io/component=controller -n ingress-nginx -o json 2>&1)
#controllerStatus=$(echo "fail" 1 2>&1)

# проверим, что controllerStatus это валидный json
if [[ $(echo $controllerStatus | jq 2>&1) =~ "parse error:" ]]; then
    controllerStatus=$(jq --null-input --arg error "$controllerStatus" '$ARGS.named')
fi

# получаем логи из ингреса
logs=$(kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx 2>&1 | tail -n 100)

# шаблоны ожидаемых записей в логе ингреса
patternIp="GET /httpbin/ip HTTP/1.1\" 200 28 \"-\" \"curl"
patternHtml="GET /httpbin/html HTTP/1.1\" 200 3741 \"-\" \"curl"
patternDelay="GET /httpbin/delay/5 HTTP/1.1\" 200 344 \"-\" \"curl"
patternPost="POST /httpbin/post HTTP/1.1\" 200 487 \"-\" \"curl"


## проверки для curl, проверяем был ли использован curl на основе логов ингреса и шаблонов запроса
# curl -v localhost:32100/httpbin/ip
hasIpRequest=$(lookupIngressLogs "$logs" "$patternIp")
# curl -v localhost:32100/httpbin/html
hasHtmlRequest=$(lookupIngressLogs "$logs" "$patternHtml")
# curl -v localhost:32100/httpbin/delay/5
hasDelayRequest=$(lookupIngressLogs "$logs" "$patternDelay")
# curl -v -XPOST localhost:32100/httpbin/post -H "Content-Type: application/json" -d'{"data":"test data here"}'
hasPostRequest=$(lookupIngressLogs "$logs" "$patternPost")

# собираем факты в результирующий json
jq --null-input \
--arg didIpRequest "$hasIpRequest" \
--arg didHtmlRequest "$hasHtmlRequest" \
--arg didDelayRequest "$hasDelayRequest" \
--arg didPostRequest "$hasPostRequest" \
--argjson controllerStatus "$controllerStatus" \
'$ARGS.named'
