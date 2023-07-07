Для конфигурации внешнего сервиса выполните пункты, указанные ниже

## 1. coздать namespace для размещения внешнего сервиса

```
kubectl create namespace mesh-external
```{{execute}}

## 2. создать секрет для хранения сертификата удостоверяющего центра

```
kubectl create -n mesh-external secret generic nginx-ca-certs --from-file=example.com.crt

```{{execute}}


## 3. создать секрет для хранения ключа и сертификата сервиса

```
kubectl create -n mesh-external secret tls nginx-server-certs --key my-nginx.mesh-external.svc.cluster.local.key --cert my-nginx.mesh-external.svc.cluster.local.crt

```{{execute}}

## 4. ознакомьтесь с конфигурацией внешнего сервиса

`external/nginx.conf`{{open}}

5. создать Kubernetes ConfigMap из конфиг файла предыдущего шага

```
kubectl create configmap nginx-configmap -n mesh-external --from-file=nginx.conf=./nginx.conf
```{{execute}}

6. применить Deployment для запуска сервера

```
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: my-nginx
  namespace: mesh-external
  labels:
    run: my-nginx
spec:
  ports:
  - port: 443
    protocol: TCP
  selector:
    run: my-nginx
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-nginx
  namespace: mesh-external
spec:
  selector:
    matchLabels:
      run: my-nginx
  replicas: 1
  template:
    metadata:
      labels:
        run: my-nginx
    spec:
      containers:
      - name: my-nginx
        image: nginx
        ports:
        - containerPort: 443
        volumeMounts:
        - name: nginx-config
          mountPath: /etc/nginx
          readOnly: true
        - name: nginx-server-certs
          mountPath: /etc/nginx-server-certs
          readOnly: true
        - name: nginx-ca-certs
          mountPath: /etc/nginx-ca-certs
          readOnly: true
      volumes:
      - name: nginx-config
        configMap:
          name: nginx-configmap
      - name: nginx-server-certs
        secret:
          secretName: nginx-server-certs
      - name: nginx-ca-certs
        secret:
          secretName: nginx-ca-certs
EOF
```{{execute}}

## Конфигурация клиента

1. Создать секреты для клиента используя сертификаты и ключи, которые были созданы ранее

```
kubectl create secret generic client-credential --from-file=tls.key=client.example.com.key \
  --from-file=tls.crt=client.example.com.crt --from-file=ca.crt=example.com.crt
```{{execute}}

2. Sleep Service

```
kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: sleep
---
apiVersion: v1
kind: Service
metadata:
  name: sleep
  labels:
    app: sleep
    service: sleep
spec:
  ports:
  - port: 80
    name: http
  selector:
    app: sleep
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sleep
spec:
  replicas: 1
  selector:
    matchLabels:
      app: sleep
  template:
    metadata:
      labels:
        app: sleep
    spec:
      terminationGracePeriodSeconds: 0
      serviceAccountName: sleep
      containers:
      - name: sleep
        image: curlimages/curl
        command: ["/bin/sleep", "3650d"]
        imagePullPolicy: IfNotPresent
        volumeMounts:
        - mountPath: /etc/sleep/tls
          name: secret-volume
      volumes:
      - name: secret-volume
        secret:
          secretName: sleep-secret
          optional: true
EOF
```{{execute}}

2. Создать RBAC для секрета

```
kubectl create role client-credential-role --resource=secret --verb=get,list,watch
kubectl create rolebinding client-credential-role-binding --role=client-credential-role --serviceaccount=default:sleep
```{{execute}}

3. DestinationRule

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

4. Проверка - отправить запрос в http://my-nginx.mesh-external.svc.cluster.local

```
kubectl exec "$(kubectl get pod -l app=sleep -o jsonpath={.items..metadata.name})" -c sleep -- curl -sS http://my-nginx.mesh-external.svc.cluster.local:443
```{{execute}}