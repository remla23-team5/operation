#!/bin/bash

kubectl apply -f mysqldb-secret.yaml
kubectl apply -f mysqldb.yaml
sleep 10
kubectl apply -f istio.yaml
