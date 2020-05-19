#!/bin/bash
set -exo pipefail

namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}')
# verify that everything is running
# kubectl wait --for=condition=Ready pod -l app=tecnotree --timeout=10s -n $namespace
