#!/bin/bash -x

namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}')
gateway=$(kubectl get pod -n $namespace -l app=$namespace-zeebe-gateway -o jsonpath="{.items[0].metadata.name}")

kubectl exec $gateway -- apt update
kubectl exec $gateway -- apt install curl -y
kubectl exec $gateeway -- curl -X PUT -H "Content-Type: application/json" http://elasticsearch-master:9200/_all/_settings -d'{ "index.blocks.read_only" : true } }'
