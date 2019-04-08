# MariaDB (MySQL) Chart

Provide MariaDB (MySQL) database service

## Chart Details

This chart will do the following:

* Install a single container with stateless MariaDB server instance

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/mariadb
```

## Configuration

Configurable values are documented in the `values.yaml`.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/mariadb
```

> **Tip**: You can use the default [values.yaml](values.yaml)
