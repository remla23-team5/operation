# Restaurant sentiment analysis by group 5

This repository contains all deployment files for the restaurant sentiment analysis web application.

## Docker Compose (Assignment 1)

**NOTE**: The setup from the `docker-compose.yaml` file uses a slightly modified version of the web application (the Docker image [ghcr.io/remla23-team5/app:docker](https://github.com/remla23-team5/app/pkgs/container/app/104772001?tag=docker)) which uses a file-based H2 database, rather than a MySQL database.

To start the web application using the `docker-compose.yaml` file, please follow these steps:

1. Clone this repository to your local machine.
```
git clone https://github.com/remla23-team5/operation.git
```
2. Navigate to the repository directory.
```
cd operation
```
3. Create a `.env` file with the necessary environment variables. A sample `.env` file is provided in the repository.
```
cp sample.env .env
```
4. Run the following command and provide your GitHub username and password/personal access token (PAT) to sign in to the GitHub Container Registry.
```
docker login ghcr.io
```
5. Run Docker Compose to start the application.
```
docker-compose up
```
6. Access the application via `http://localhost:APP_PORT` (replace `APP_PORT` with the actual port number specified in the `.env` file or with 8000, if no `.env` file exists).

### Requirements

- Docker
- Docker Compose

### Environment Variables

The application makes use of the following environment variables:

- `APP_PORT`: the port number on which the application should listen. By default, it is set to 8000, but a different port number can be set using the `.env` file (NOTE: the value 8080 cannot be used, because that port number is already taken).

### Codebase Overview

To help you understand the code base, here are some pointers to important files:

- `docker-compose.yaml`: the Docker Compose file used to deploy the web application
- `sample.env`: a sample `.env` file

Additionally, in order to get more familiar with the web application, take a look at the documentation of the [app](https://github.com/remla23-team5/app) and [model-service](https://github.com/remla23-team5/model-service) repositories.

## Monitoring on Kubernetes (Assignment 2)

There are two ways to deploy the setup for assignment 2 - with or without using the provided Helm chart.

### Without using the Helm chart

To deploy the setup for assignment 2 without using Helm, please follow these steps:

1. Clone this repository to your local machine.
```
git clone https://github.com/remla23-team5/operation.git
```
2. Navigate to the repository directory.
```
cd operation
```
3. Create a new cluster.
```
minikube start -p monitoring
```
4. Enable the `ingress` addon for the new cluster.
```
minikube addons enable ingress -p remla
``` 
5. Install the Prometheus stack on the new cluster using the following commands:
```
helm repo add prom-repo https://prometheus-community.github.io/helm-charts
helm repo update
helm install myprom prom-repo/kube-prometheus-stack
```
6. Run the following commands:
```
kubectl apply -f mysqldb-secret.yaml
kubectl apply -f mysqldb.yaml
kubectl apply -f sentiment-analysis.yaml
```

### Using the Helm chart

To deploy the setup for assignment 2 using the provided Helm chart, please follow these steps:

1. Clone this repository to your local machine.
```
git clone https://github.com/remla23-team5/operation.git
```
2. Navigate to the repository directory.
```
cd operation
```
3. Create a new cluster.
```
minikube start -p monitoring
```
4. Enable the `ingress` addon for the new cluster.
```
minikube addons enable ingress -p remla
``` 
5. Run the following commands: (where `<NAME>` is a placeholder for a string)
```
kubectl apply -f mysqldb-secret.yaml
helm dependency build helm/monitoring/
helm install <NAME> helm/monitoring/
```

### Using the web application

The web application can be accessed through the `ingress-nginx-controller` service using a tunnel.

To access Prometheus, please run the command `kubectl port-forward service/myprom-kube-prometheus-sta-prometheus <PORT>:9090`, if you have deployed the setup without using the provided Helm chart. Otherwise, run the command `kubectl port-forward service/<NAME>-kube-prometheus-prometheus <PORT>:9090`, where `<NAME>` is the same string you used when deploying the setup and `<PORT>` is a placeholder for some port number. After that, you will be able to access Prometheus by going to `localhost:<PORT>`.

To access Grafana, please run the command `kubectl port-forward service/myprom-grafana <PORT>:80`, if you have deployed the setup without using the provided Helm chart. Otherwise, run the command `kubectl port-forward service/<NAME>-grafana <PORT>:80`, where `<NAME>` is the same string you used when deploying the setup and `<PORT>` is a placeholder for some port number. After that, you will be able to access Grafana by going to `localhost:<PORT>`.

**NOTE**: We provide a Grafana dashboard (the file `grafana-dashboard.json`) which can be used to inspect the app-specific metrics exposed by the web application. If you deploy the setup without using the provided Helm chart, then you will have to manually import the provided dashboard to Grafana. However, if you deploy the setup using the provided Helm chart, then Helm will automatically import the provided dashboard to Grafana.

## Istio (Assignment 3)

### Traffic Management

In order to deploy the setup for assignment 3, please follow these steps:
1. Create a new cluster with at least 8GB RAM.
```
minikube start --memory=7951 --cpus=4 -p istio
```
2. Run the following commands (the `setup-istio.sh` script will install Prometheus, Grafana, Jaeger and Kiali):
```
./setup-istio.sh
kubectl apply -f mysqldb-secret.yaml
```
3. Deploy the setup using the provided Helm chart by running the command `helm install <NAME> helm/istio/` (where `<NAME>` is a placeholder for a string) or without using the provided Helm chart by running the command `./setup-kubernetes.sh`.

Run the command `minikube tunnel`, if needed, and then either run the command `curl localhost` or go to [localhost:80](http://localhost/) in your browser. Submitting multiple reviews will direct you to either v1 or v2 with a 50% probability. You can stabilize to a specific version by providing a request header `version` and setting its value to either `v1` or `v2`.

To clean up, run the command `helm delete <NAME>`, if you deployed the setup using the provided Helm chart (where `<NAME>` is the same string you used when deploying the setup), or the command `./teardown-kubernetes.sh`, otherwise.

### Additional Use Case (Rate-Limit)

As an additional use case, we have implemented rate-limiting. The limit is 10/minute. If you exceed it, you will be blocked and will no longer be able to submit a review.
