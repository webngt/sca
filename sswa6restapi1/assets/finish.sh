#!/bin/bash

# функция проверяет наличие заданного шаблона в логе
#
# в переменной $1 передаем содержимое лога
# в переменной $2 передаем шаблон
function request {
    while read line; do
        if [[ $line =~ $2 ]] ;then
            echo "true"
            return
        fi
    done <<< "$1"

    echo "false"
    return
}

# получаем логи из ингреса
logs=$(kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx | tail -n 100)

patternIp="GET /httpbin/ip HTTP/1.1\" 200 28 \"-\" \"curl"
patternHtml="GET /httpbin/html HTTP/1.1\" 200 3741 \"-\" \"curl"
patternDelay="GET /httpbin/delay/5 HTTP/1.1\" 200 344 \"-\" \"curl"
patternPost="POST /httpbin/post HTTP/1.1\" 200 487 \"-\" \"curl"


# проверяем был ли выполнен curl -v localhost:32100/httpbin/ip
hasIpRequest=$(request "$logs" "$patternIp")
hasHtmlRequest=$(request "$logs" "$patternHtml")
hasDelayRequest=$(request "$logs" "$patternDelay")
hasPostRequest=$(request "$logs" "$patternPost")

echo "$res"
