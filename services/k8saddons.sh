#!/bin/bash
#
#	Kubernetes Add-ons Installation
#

# Dashboard und User einrichten - Zugriff via kubectl proxy und Token mittels kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep kubernetes-dashboard | awk ' { print $1 }') Ermitteln
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
kubectl apply -f https://raw.githubusercontent.com/mc-b/lernkube/master/addons/dashboard-admin.yaml

# Install ingress bare metal, https://kubernetes.github.io/ingress-nginx/deploy/
kubectl apply -f https://raw.githubusercontent.com/mc-b/lernkube/master/addons/ingress-mandatory.yaml
kubectl apply -f https://raw.githubusercontent.com/mc-b/lernkube/master/addons/service-nodeport.yaml

# Weave Scope 
kubectl apply -f 'https://cloud.weave.works/k8s/scope.yaml?k8s-version='$(kubectl version | base64 | tr -d '\n')