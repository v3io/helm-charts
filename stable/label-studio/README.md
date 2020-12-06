# Label Studio

Provides installation of the Label Studio service

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release v3io-stable/label-studio
```

## Configuration

Configurable values are documented in the `values.yaml`.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml v3io-stable/label-studio
```

> **Tip**: You can use the default [values.yaml](values.yaml)
