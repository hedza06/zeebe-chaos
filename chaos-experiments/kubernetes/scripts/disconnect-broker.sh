#!/bin/bash
set -exuo pipefail

kubectl exec $1 -- tc qdisc replace dev eth0 root netem loss 100%
