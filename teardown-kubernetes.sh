#!/bin/bash

kubectl delete -f mysqldb-secret.yaml
kubectl delete -f mysqldb.yaml
kubectl delete -f istio.yaml

kubectl delete pvc -l 'app in (mysqldb)'
