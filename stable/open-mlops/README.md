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
$ helm --namespace mlops install my-mlops v3io-stable/open-mlops
```

Forward the nuclio dashboard port:
```sh
kubectl port-forward $(kubectl get pod -l nuclio.io/app=dashboard -o jsonpath='{.items[0].metadata.name}') 8070:8070
```


## Configuration
Configurable values are documented in the `values.yaml`, override those the usual way.
TBD - values of requirements?

## Uninstalling the Chart
```bash
$ helm --namespace mlops uninstall my-mlops
```
#### Note on terminating pods and hanging resources
It is important to note that this chart generates several persistent volume claims and also provisions an NFS
provisioning server, to provide the user with persistency (via pvc) out of the box.
Because of the persistency of PV/PVC resources, after installing this chart, PVs and PVCs will be created,
And upon uninstallation, any hanging / terminating pods will hold the PVCs and PVs respectively, as those
Prevent their safe removal.
Because pods stuck in terminating state seem to be a never-ending plague in k8s, please note this,
And don't forget to clean the remaining PVCs and PVCs

Handing stuck-at-terminating pods:
```bash
$ helm --namespace mlops delete pod --force --grace-period=0 <pod-name>
```

Reclaim dangling persistency resources:
```bash
# To list PVCs
$ helm --namespace mlops get pvc
...

# To remove a PVC
$ helm --namespace mlops delete pvc <pvc-name>
...

# To list PVs
$ helm --namespace mlops get pv
...

# To remove a PVC
$ helm --namespace mlops delete pvc <pv-name>
...
```
