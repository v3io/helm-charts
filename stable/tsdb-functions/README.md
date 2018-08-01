# TSDB functions Chart

TSDB functions is a set of functions demonstrating working with Iguazio's time sereis database

## Chart Details

This chart will do the following:

* Deploys 2 functions as ingest and query
* Creates a project which they both sit under

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/tsdb-functions
```

## Configuration

Configurable values are documented in the `values.yaml`.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/tsdb-functions
```

> **Tip**: You can use the default [values.yaml](values.yaml)
