#!/bin/bash
set -exuo pipefail

broker=$1
namespace=$2

kubectl exec -n $namespace $broker -- apt update
kubectl exec -n $namespace $broker -- apt install -y stress

kubectl exec -n $namespace $broker -- stress --cpu 256 --vm 32 --vm-bytes 4M --timeout 180
