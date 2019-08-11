# Kubeflow pipelines service

Provides installation of the Pipelines workflow CRDs, RBAC and services, and Mysql (with fuse backend) as persistency

## Chart Details

This chart will do one or more of the following:

* Install Kubeflow Pipelines CRDs
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

## TODOS:
There are some unresolved issues in this project
* we are using two non upstream images:
1. quay.io/iguazio/ml-pipelines-frontend-v3io
2. quay.io/iguazio/ml-pipeline-api-server
once 0.1.26 will be released we can update ml-pipeline-api-server to upstream
* naming conventions aren't as desired:
when i tried changing the api-server app name to our convention (ml-pipeline to pipelines-api-server),
i got an error the persistent agent can't find it. this is hardcoded and we choose not to make a fix for it in the code.
same with ml-pipeline-ui once changed the nginx stopped responding.
there might be more issues that i didn't encounter with naming conventions.

> **Tip**: You can use the default [values.yaml](values.yaml)
