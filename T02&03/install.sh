#!/usr/bin/env bash
set -euo pipefail

EG_VERSION="${EG_VERSION:-v1.9.1}"
DIR="$(dirname "$0")"

kubectl apply --server-side -f "https://github.com/envoyproxy/gateway/releases/download/${EG_VERSION}/install.yaml"
kubectl wait --timeout=5m -n envoy-gateway-system deployment/envoy-gateway --for=condition=Available

kubectl apply -f "$DIR/app.yaml"
kubectl apply -f "$DIR/gateway.yaml"
