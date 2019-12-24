#!/bin/bash
#
#	Kubernetes Add-ons Installation
#

# Dashboard und User einrichten - Zugriff via kubectl proxy und Token mittels kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep kubernetes-dashboard | awk ' { print $1 }') Ermitteln
sudo su - ubuntu -c "kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml"
sudo su - ubuntu -c "kubectl apply -f https://raw.githubusercontent.com/mc-b/lernkube/master/addons/dashboard-admin.yaml"

# Standard Persistent Volume und Claim
sudo su - ubuntu -c "kubectl apply -f https://raw.githubusercontent.com/mc-b/lernmaas/master/MAAS/data/DataVolume.yaml"
	
# Weave Scope 
sudo su - ubuntu -c "kubectl apply -f 'https://cloud.weave.works/k8s/scope.yaml?k8s-version='$(kubectl version | base64 | tr -d '\n')"
