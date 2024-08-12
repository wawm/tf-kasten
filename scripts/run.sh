#!/bin/bash
aws eks update-kubeconfig --region ap-southeast-1 --name eks-demo
#kubectl create clusterrolebinding cluster-system-anonymous --clusterrole=cluster-admin --user=system:anonymous
kubectl apply -f scripts/nginx.yaml
