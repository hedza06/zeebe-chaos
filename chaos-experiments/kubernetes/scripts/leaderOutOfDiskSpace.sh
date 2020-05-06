#!/bin/bash -x

set -xoeu pipefail

partition=$1

namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}')
pod=$(kubectl get pod -n $namespace -l app=$namespace-zeebe -o jsonpath="{.items[0].metadata.name}")
gateway=$(kubectl get pod -n $namespace -l app=$namespace-zeebe-gateway -o jsonpath="{.items[0].metadata.name}")


# To print the topology in the journal
kubectl exec $gateway -n $namespace -- zbctl status --insecure

partition=$1


# determine leader for partition
state=Leader
index=$[$(kubectl exec $gateway -n $namespace -- zbctl status --insecure \
  | grep "Partition $partition" \
  | grep -n "$state" -m 1 \
  | sed 's/\([0-9]*\).*/\1/') - 1]

podPrefix=$(echo $pod | sed 's/\(.*\)\([0-9]\)$/\1/')

# LEADER for given partition
leader=$podPrefix$index

i=0
freespace=$(kubectl exec -it $leader bash -- df -Ph data/ | awk 'NR==2 {print $4}' | cut -dG -f1 | cut -d. -f1);
while [ $freespace -gt 4 ];
do
  kubectl exec -it $leader bash -- fallocate -l 1G data/fault$i;
  i=$((i+1))
  freespace=$(kubectl exec -it $leader bash -- df -Ph data/ | awk 'NR==2 {print $4}' | cut -dG -f1 | cut -d. -f1)
done
