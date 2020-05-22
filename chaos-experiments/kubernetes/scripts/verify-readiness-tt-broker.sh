#!/bin/bash
set -exo pipefail

# verify that everything is running
# kubectl wait --for=condition=Ready pod -l app=tecnotree --timeout=10s -n $namespace
