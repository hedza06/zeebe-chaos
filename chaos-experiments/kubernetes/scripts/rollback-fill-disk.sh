#!/bin/bash -x

set -xoeu pipefail

# LEADER for given partition
leader=$1

kubectl exec -it $leader bash -- rm -rf data/fault
kubectl exec -it $leader -- df -h data/ --output=avail
