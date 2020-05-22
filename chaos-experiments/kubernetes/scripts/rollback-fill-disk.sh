#!/bin/bash -x

set -xoeu pipefail

# LEADER for given partition
leader=$1
namespace=$2

kubectl exec -n $namespace -it $leader bash -- rm -rf data/fault
kubectl exec -n $namespace -it $leader -- df -h data/ --output=avail
