#!/bin/bash
set -exuo pipefail

kubectl scale --replicas=5 statefulset broker
