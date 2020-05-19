#!/bin/bash
set -exuo pipefail

broker=$1

kubectl exec $broker -- apt update
kubectl exec $broker -- apt install -y stress

kubectl exec $broker -- stress --cpu 256 --vm 32 --vm-bytes 4M --timeout 180
