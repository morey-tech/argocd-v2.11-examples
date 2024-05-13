#!/bin/bash

echo "post-start start" >> ~/status

# this runs in background each time the container starts

# Ensure kubeconfig is set up. 
k3d kubeconfig merge dev --kubeconfig-merge-default

kubectl apply -k argocd
# kubectl apply -f apps.yaml

kubectl wait deployment -n argocd --all --for=condition=Available=True --timeout=90s
ARGOCD_ADMIN_PASSWORD="$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)"
echo "${ARGOCD_ADMIN_PASSWORD}" > ~/argo-cd-admin-password.txt

argocd login \
  "localhost:31443" \
  --username admin \
  --password ${ARGOCD_ADMIN_PASSWORD} \
  --grpc-web \
  --insecure

echo "Argo CD admin password: ${ARGOCD_ADMIN_PASSWORD}"

echo "post-start complete" >> ~/status