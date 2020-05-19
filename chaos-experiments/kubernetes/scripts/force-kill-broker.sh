#!/bin/bash
set -exuo pipefail

##TODO: This is cause OOM on all other brokers
kubectl delete pod --force=true --grace-period=0 $1
kubectl scale --replicas=4 statefulset broker
