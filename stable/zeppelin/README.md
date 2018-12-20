# Apache Zeppelin Helm Chart

Apache Zepplin is a general-purpose notebooks

* https://zeppelin.apache.org/

Inspired from Helm Classic chart https://github.com/helm/charts

## Prerequisites

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/zeppelin
```

## Configuration

The following tables lists the configurable parameters of the zeppelin chart and their default values.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/zeppelin
```


> **Tip**: You can use the default [values.yaml](values.yaml)
