#!/bin/bash

set -xoeu pipefail

partition=$1

namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}')
pod=$(kubectl get pod -n $namespace -l app=$namespace-zeebe -o jsonpath="{.items[0].metadata.name}")
gateway=$(kubectl get pod -n $namespace -l app=$namespace-zeebe-gateway -o jsonpath="{.items[0].metadata.name}")


# To print the topology in the journal
kubectl exec $gateway -n $namespace -- zbctl status --insecure

partition=$1


# determine followers for partition
state=Follower
followers=( $(kubectl exec $gateway -n $namespace -- zbctl status --insecure \
  | grep "Partition $partition" \
  | grep -n "$state" -m 2 \
  | sed 's/\([0-9]*\).*/\1/') )

echo "${followers[@]}"
for j in "${followers[@]}"
do
    index=$(( $j - 1 ))
	echo "Filling disk for broker-$index"

    podPrefix=$(echo $pod | sed 's/\(.*\)\([0-9]\)$/\1/')

    # follower for given partition
    follower=$podPrefix$index

    i=0
    freespace=$(kubectl exec -it $follower bash -- df -Ph data/ | awk 'NR==2 {print $4}' | cut -dG -f1 | cut -d. -f1);
    while [ $freespace -gt 4 ];
    do
      kubectl exec -it $follower bash -- fallocate -l 1G data/fault$i;
      i=$((i+1))
      freespace=$(kubectl exec -it $follower bash -- df -Ph data/ | awk 'NR==2 {print $4}' | cut -dG -f1 | cut -d. -f1)
    done
    echo "$freespace gb left on broker-$index"
done
