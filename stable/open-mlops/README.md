# Open MLOPS: MLOPS Open Source bundle

This Helm charts bundles open source software stack for advanced ML operations

## Chart Details

The Open MLOPs chart includes the following stack:

* Nuclio - https://github.com/nuclio/nuclio
* MLRun - https://github.com/mlrun/mlrun
* Jupyter - https://github.com/jupyter/notebook (+MLRun integrated)
* NFS - https://github.com/kubernetes-retired/external-storage/tree/master/nfs
* MPI Operator - https://github.com/kubeflow/mpi-operator

## Installing the Chart
Create a namespace for the deployed components:
```bash
$ kubectl create ns mlops
```

Add the v3io-stable helm chart repo
```bash
$ helm repo add v3io-stable https://v3io.github.io/helm-charts/stable
```

To install the chart with the release name `my-mlops`:

```bash
$ helm --namespace mlops install --name my-mlops v3io-stable/open-mlops
```

Forward the nuclio dashboard port:
```sh
kubectl port-forward $(kubectl get pod -l nuclio.io/app=dashboard -o jsonpath='{.items[0].metadata.name}') 8070:8070
```



## Configuration
Configurable values are documented in the `values.yaml`, override those the usual way.
TBD - values of requirements?