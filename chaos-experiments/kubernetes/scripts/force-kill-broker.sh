#!/bin/bash
set -exuo pipefail

namespace=$2

##TODO: This is cause OOM on all other brokers
kubectl delete pod --force=true --grace-period=0 -n $namespace $1
kubectl scale --replicas=4 statefulset broker -n $namespace
