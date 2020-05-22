#!/bin/bash
set -exuo pipefail

namespace=$2

kubectl scale --replicas=5 statefulset broker -n $namespace
