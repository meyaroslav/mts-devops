#!/usr/bin/env bash
set -euo pipefail

FLANNEL_VERSION="${FLANNEL_VERSION:-v0.27.0}"

sudo kubeadm init --config "$(dirname "$0")/kubeadm-config.yaml"

mkdir -p "$HOME/.kube"
sudo cp /etc/kubernetes/admin.conf "$HOME/.kube/config"
sudo chown "$(id -u):$(id -g)" "$HOME/.kube/config"

kubectl apply -f "https://github.com/flannel-io/flannel/releases/download/${FLANNEL_VERSION}/kube-flannel.yml"
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
kubectl wait --for=condition=Ready node --all --timeout=300s
