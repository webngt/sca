Выполните следующую команду для запуска кластера и дождитесь ее завершения

```
launch.sh
```{{execute}}

Включим [istio injection](https://istio.io/latest/docs/setup/additional-setup/sidecar-injection/) для Namespace default при помощи сделующей команды

```
kubectl label namespace default istio-injection=enabled
```{{execute}}

Таким образом мы обозначили, что Namespace default находится под управлением Istio Service Mesh и готов к развертыванию прикладного сервиса


Также coздайте namespace для размещения внешнего сервиса

```
kubectl create namespace mesh-external
```{{execute}}

Кроме этого вам понадобится включить Egress Gateway, для этого выполните слудющую команду

```
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
istioctl install -y \
--set components.egressGateways[0].name=istio-egressgateway \
--set components.egressGateways[0].enabled=true \
--set values.pilot.resources.requests.memory=512Mi \
--set values.pilot.resources.requests.cpu=50m \
--set values.global.proxy.resources.requests.cpu=10m
```{{execute}}


