#!/usr/bin/env bash
set -euo pipefail

SEL="gateway.envoyproxy.io/owning-gateway-name=web-gateway"

until kubectl get svc -n envoy-gateway-system -l "$SEL" -o name | grep -q .; do sleep 3; done
PORT=$(kubectl get svc -n envoy-gateway-system -l "$SEL" -o jsonpath='{.items[0].spec.ports[0].nodePort}')

curl -fsS --retry 30 --retry-delay 3 --retry-connrefused "http://127.0.0.1:${PORT}/"
kubectl logs deploy/web --tail=3
