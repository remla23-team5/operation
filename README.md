# Restaurant sentiment analysis by group 5

This repository contains all deployment files for Docker Compose to deploy and run the restaurant sentiment analysis application.

## Getting Started

To start the application, please follow these steps:

1. Clone the repository to your local machine.
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

## Requirements

- Docker
- Docker Compose

## Environment Variables

The application makes use of the following environment variables:

- `APP_PORT`: the port number which the application should listen on. By default, it is set to 8000, but a different port number can be set using the `.env` file (NOTE: the value 8080 cannot be used, because that port number is already taken).

## Codebase Overview

To help you understand the code base, here are some pointers to interesting files:

- `docker-compose.yml`: the Docker Compose file used to deploy the application
- `sample.env`: a sample .env file

For more information, please refer to the documentation in the repository.

## Monitoring on Kubernetes (Assignment 2)
`kubectl apply -f sentiment-analysis.yaml`
TODO: Ivan, could you add the other steps here please?

## Helm Chart

```
helm install monitoring helm/monitoring
helm delete monitoring
```

TODO: Ivan, Is the thing below correct?
`minikube service app-serv --url -p remla`

# Istio (Assignment 3)

## Traffic Management

Assign docker atleast 8GB ram.

```
minikube start --memory=7951 --cpus=4 -p istio
./setup-istio.sh
kubectl apply -f mysqldb-secret.yaml
```

For helm use `helm install istio helm/istio` and for kubectl use `./setup-kubernetes.sh`. To cleanup, use `help delete istio` or `./teardown-kubernetes.sh`.

The setup script will install prometheus, jaeger and kiali.

Use minikube tunnel if needed and then `curl localhost` or open [localhost:80](http://localhost/) on your browser. Submitting multiple reviews will direct you to v1 and v2 with probability 50 on both. You can stabilize to a specific version by setting a header `version` and giving it values of either `v1` or `v2`.

## Additional Use Case (Rate-Limit)

The rate is 10/minute. If you try to exceed, you will be blocked and can not make a review.
