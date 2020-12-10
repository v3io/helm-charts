# Label Studio

Provides installation of the Label Studio service

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release v3io-stable/label-studio
```

## Configuration

Configurable values are documented in the `values.yaml`.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

```bash
$ helm install my-release --set project.name=project_a v3io-stable/label-studio
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml v3io-stable/label-studio
```


Example of installing the chart and setting a node port:
```bash
$ helm install my-release --set service.type=NodePort --set service.nodePort=30030 v3io-stable/label-studio
```

> **Tip**: You can use the default [values.yaml](values.yaml)
