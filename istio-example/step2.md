## Включить egress gateway

Для включения Egress Gateway необходимо выполнить следующую команду.

```
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
istioctl install \
--set components.egressGateways[0].name=istio-egressgateway \
--set components.egressGateways[0].enabled=true \
--set values.pilot.resources.requests.memory=512Mi \
--set values.pilot.resources.requests.cpu=50m \
--set values.global.proxy.resources.requests.cpu=10m
```{{execute}}

Другие способы включения Gateway описаны в документации istio, см. [Deploy Instio](https://istio.io/latest/docs/tasks/traffic-management/egress/egress-gateway/#deploy-istio-egress-gateway)

Этот раздел явлется обязательным. Но в обычной рабочей ситуации ваш DevOps инженер скорее всего уже сделал необходимые действия для включения Egress Gateway. 

## Сертификаты и ключи для клиента и внешнего сервиса

1. Создать корневой сертификат и приватный ключ

```
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -subj '/O=example Inc./CN=example.com' -keyout example.com.key -out example.com.crt
```{{execute}}

2. Создать сертификат для внешнего сервиса

```
openssl req -out my-nginx.mesh-external.svc.cluster.local.csr -newkey rsa:2048 -nodes -keyout my-nginx.mesh-external.svc.cluster.local.key -subj "/CN=my-nginx.mesh-external.svc.cluster.local/O=some organization"
openssl x509 -req -sha256 -days 365 -CA example.com.crt -CAkey example.com.key -set_serial 0 -in my-nginx.mesh-external.svc.cluster.local.csr -out my-nginx.mesh-external.svc.cluster.local.crt
```{{execute}}

3. Создать сертификат для клиента

```
openssl req -out client.example.com.csr -newkey rsa:2048 -nodes -keyout client.example.com.key -subj "/CN=client.example.com/O=client organization"
openssl x509 -req -sha256 -days 365 -CA example.com.crt -CAkey example.com.key -set_serial 1 -in client.example.com.csr -out client.example.com.crt
```{{execute}}

## Kонфигурация внешнего сервиса

1. coздать namespace для размещения внешнего сервиса

```
kubectl create namespace mesh-external
```{{execute}}

2. создать секреты для хранения сертификатов сервиса, которые мы создали ранее и CA

```
kubectl create -n mesh-external secret tls nginx-server-certs --key my-nginx.mesh-external.svc.cluster.local.key --cert my-nginx.mesh-external.svc.cluster.local.crt
kubectl create -n mesh-external secret generic nginx-ca-certs --from-file=example.com.crt
```{{execute}}

3. создать config файл для NGINX сервера

```
cat <<\EOF > ./nginx.conf
events {
}

http {
  log_format main '$remote_addr - $remote_user [$time_local]  $status '
  '"$request" $body_bytes_sent "$http_referer" '
  '"$http_user_agent" "$http_x_forwarded_for"';
  access_log /var/log/nginx/access.log main;
  error_log  /var/log/nginx/error.log;

  server {
    listen 443 ssl;

    root /usr/share/nginx/html;
    index index.html;

    server_name my-nginx.mesh-external.svc.cluster.local;
    ssl_certificate /etc/nginx-server-certs/tls.crt;
    ssl_certificate_key /etc/nginx-server-certs/tls.key;
    ssl_client_certificate /etc/nginx-ca-certs/example.com.crt;
    ssl_verify_client on;
  }
}
EOF
```{{execute}}

4. создать Kubernetes ConfigMap из конфиг файла предыдущего шага

```
kubectl create configmap nginx-configmap -n mesh-external --from-file=nginx.conf=./nginx.conf
```{{execute}}

5. применить Deployment для запуска сервера

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


## Конфигурация гейтвея


1. Создать секрет

```
kubectl create secret -n istio-system generic client-credential --from-file=tls.key=client.example.com.key \
  --from-file=tls.crt=client.example.com.crt --from-file=ca.crt=example.com.crt
```{{execute}}

2. Создать объект Gateway и DestinationRule для исходящего трафика

```
kubectl apply -f - <<EOF
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: istio-egressgateway
spec:
  selector:
    istio: egressgateway
  servers:
  - port:
      number: 443
      name: https
      protocol: HTTPS
    hosts:
    - my-nginx.mesh-external.svc.cluster.local
    tls:
      mode: ISTIO_MUTUAL
---
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: egressgateway-for-nginx
spec:
  host: istio-egressgateway.istio-system.svc.cluster.local
  subsets:
  - name: nginx
    trafficPolicy:
      loadBalancer:
        simple: ROUND_ROBIN
      portLevelSettings:
      - port:
          number: 443
        tls:
          mode: ISTIO_MUTUAL
          sni: my-nginx.mesh-external.svc.cluster.local
EOF
```{{execute}}

3. VirtualService

```
kubectl apply -f - <<EOF
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: direct-nginx-through-egress-gateway
spec:
  hosts:
  - my-nginx.mesh-external.svc.cluster.local
  gateways:
  - istio-egressgateway
  - mesh
  http:
  - match:
    - gateways:
      - mesh
      port: 80
    route:
    - destination:
        host: istio-egressgateway.istio-system.svc.cluster.local
        subset: nginx
        port:
          number: 443
      weight: 100
  - match:
    - gateways:
      - istio-egressgateway
      port: 443
    route:
    - destination:
        host: my-nginx.mesh-external.svc.cluster.local
        port:
          number: 443
      weight: 100
EOF
```{{execute}}

4. DR 

```
kubectl apply -n istio-system -f - <<EOF
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: originate-mtls-for-nginx
spec:
  host: my-nginx.mesh-external.svc.cluster.local
  trafficPolicy:
    loadBalancer:
      simple: ROUND_ROBIN
    portLevelSettings:
    - port:
        number: 443
      tls:
        mode: MUTUAL
        credentialName: client-credential # this must match the secret created earlier to hold client certs
        sni: my-nginx.mesh-external.svc.cluster.local
EOF
```{{execute}}