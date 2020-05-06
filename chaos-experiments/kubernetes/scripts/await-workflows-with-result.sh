#!/bin/bash
set -exo pipefail

namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}')
pod=$(kubectl get pod -n $namespace -l app=$namespace-zeebe -o jsonpath="{.items[0].metadata.name}")

for i in {0..10}
do
  kubectl exec $pod -n $namespace -- zbctl --insecure create instance benchmark --withResult
done