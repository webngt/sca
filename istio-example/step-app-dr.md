Выпольните следующие команды, которые создадут роль client-credential-role и сделают ее привязку к ServiceAccount

```
kubectl create role client-credential-role --resource=secret --verb=get,list,watch
kubectl create rolebinding client-credential-role-binding --role=client-credential-role --serviceaccount=default:sleep
```{{execute}}

Создадим объект DestinationRule

```
kubectl apply -f - <<EOF
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: originate-mtls-for-nginx
spec:
  workloadSelector:
    matchLabels:
      app: sleep
  host: my-nginx.mesh-external.svc.cluster.local
  trafficPolicy:
    loadBalancer:
      simple: ROUND_ROBIN
    portLevelSettings:
    - port:
        number: 443
      tls:
        mode: MUTUAL
        credentialName: client-credential # this must match the secret created earlier to hold client certs, and works only when DR has a workloadSelector
        sni: my-nginx.mesh-external.svc.cluster.local # this is optional
EOF
```{{execute}}

Проверим, как теперь

```
kubectl exec "$(kubectl get pod -l app=sleep -o jsonpath={.items..metadata.name})" -c sleep -- curl -svS http://my-nginx.mesh-external.svc.cluster.local:443
```{{execute}}


