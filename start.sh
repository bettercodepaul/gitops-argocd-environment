#!bin/bash
cd setup
kind delete cluster  --name argo-cd && \
kind create cluster --config kind-config.yaml && \
kubectl apply -f install-ingress-nginx.yaml && \
kubectl wait -n ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s && \
kubectl create namespace argocd && \
kubectl apply -n argocd -f install-argocd.yaml && \
kubectl apply -n argocd -f ingress.yaml && \
kubectl wait -n argocd \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/name=argocd-server \
  --timeout=90s && \
echo ------------------- && \
echo Initial Argo CD credentails: && \
echo User: admin && \
echo Password: $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo) && \
open http://localhost/argocd