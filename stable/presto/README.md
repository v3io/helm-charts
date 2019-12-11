# Presto Chart

[Presto](https://prestosql.io/) Presto is a high performance, distributed SQL query engine for big data.

## Chart Details

This chart will do the following:

* Install coordinator and worker servers
* Install a configmaps for coordinator, worker and catalogs
* Install a service

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/presto
```

## Configuration

Configurable values are documented in the `values.yaml`.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/presto
```

> **Tip**: You can use the default [values.yaml](values.yaml)
