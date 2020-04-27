# Kubernetes Pod Headless Service Operator
This is a Kubernetes operator that watches Pods with the annotation `srcd.host/create-headless-service: "true"`, if this annotation is found the operator will create a Headless Service with the pod's name and an Endpoint pointing to the Pod IP. This allows for the Pod's hostname to be resolvable by DNS, this is a requirement needed by certain applications.

## Limitations
This will only work if your Pod's name is maximum 63 characters as this is the maximum length for a service name.

# Installation

This tool is made to run in cluster as a Deployment. For testing purposes it can also run locally with a connection to a Kubernetes cluster.

## Helm

```bash
~ $ helm install k8s-pod-headless-service-operator --set app.namespace=default-tenant
```

# Configuration

* envvar: `NAMESPACE` flag: `--namespace` The namespace to watch, by default it watches all namespaces
* envvar: `POD_ANNOTATION` flag: `--pod-annotation` Pod annotation that needs to be set to `true` to be picked up by the operator. Default: `srcd.host/create-headless-service`
* envvar: `KUBERNETES_CONTEXT` flag: `--context` If this is set it will not attempt to load the in-cluster service account but loads the context value out of `$HOME/.kube/config`

# License
Apache License Version 2.0
