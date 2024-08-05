#!/bin/bash
aws eks update-kubeconfig --region ap-southeast-1 --name kasten-demo
kubectl create clusterrolebinding cluster-system-anonymous --clusterrole=cluster-admin --user=system:anonymous
kubectl apply -f scripts/test1.yaml
