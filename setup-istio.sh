#!/bin/bash

istioctl install -y
kubectl label ns default istio-injection=enabled

kubectl apply -f ./addons/prometheus.yaml
kubectl apply -f ./addons/jaeger.yaml
kubectl apply -f ./addons/kiali.yaml
