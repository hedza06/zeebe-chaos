#!/bin/bash
set -exuo pipefail

# kubectl delete pod --force=true --grace-period=0 $1
kubectl scale --replicas=4 statefulset broker
