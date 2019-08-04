# Kubeflow pipelines operator

Provides installation of the Pipelines job CRDs, RBAC and service, and Mysql as DB

## Chart Details

This chart will do one or more of the following:

* Install Kubeflow Pipelines job CRDs
* Install Mysql DB
* Install The Kubeflow Pipelines deployment (operator pod) and the needed rbac (namespaced)

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release v3io-stable/pipelines
```

## Configuration

Configurable values are documented in the `values.yaml`.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml v3io-stable/pipelines
```

> **Tip**: You can use the default [values.yaml](values.yaml)
