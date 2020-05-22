#!/bin/bash -x

set -xoeu pipefail

namespace=$2
# LEADER for given partition
leader=$1
kubectl exec -n $namespace -it $leader bash -- mkdir -p data/fault

i=1
freespace=$(kubectl exec -n $namespace -it $leader bash -- df -B 1M  data/ | awk 'NR==2 {print $4}' | cut -d. -f1);
while [ $freespace -gt 10240 ];
do
  kubectl exec -n $namespace -it $leader bash -- fallocate -l 10G data/fault/fault$i;
  i=$((i+1))
  freespace=$(kubectl exec -n $namespace -it $leader bash -- df -B 1M  data/ | awk 'NR==2 {print $4}' | cut -d. -f1);
done

while [ $freespace -gt 1 ];
do
  kubectl exec -n $namespace -it $leader bash -- fallocate -l 1G data/fault/fault$i;
  i=$((i+1))
  # freespace=$(kubectl exec -it $leader bash -- df -Ph data/ | awk 'NR==2 {print $4}' | cut -dG -f1 | cut -d. -f1)
  freespace=$(kubectl exec -n $namespace -it $leader bash -- df -B 1M  data/ | awk 'NR==2 {print $4}' | cut -d. -f1);
done

kubectl exec -n $namespace -it $leader -- df -h data/ --output=avail
