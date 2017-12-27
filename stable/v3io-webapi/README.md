# V3IO WebApi Helm Chart

TBD

## Chart Details
This chart will do the following:

* 1x Simple Cache for registering node to pod IP resolution
* 1x V3IO WebApi running as DaemonSet

## Prerequisites

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release v3io-webapi
```

## Configuration

The following tables lists the configurable parameters of the v3io chart and their default values.

### V3IO

| Parameter               | Description                        | Default                                                    |
| ----------------------- | ---------------------------------- | ---------------------------------------------------------- |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml v3io-webapi
```


> **Tip**: You can use the default [values.yaml](values.yaml)
