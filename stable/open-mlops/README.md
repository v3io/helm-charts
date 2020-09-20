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

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/open-mlops
```

## Configuration
Configurable values are documented in the `values.yaml`, override those the usual way.
TBD - values of requirements?